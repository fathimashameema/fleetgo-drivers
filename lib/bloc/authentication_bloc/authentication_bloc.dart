import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DriverRepo driverRepo;
  final FirestoreRepo firestoreRepo;
  final StorageRepo storageRepo;
  final User? user;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc(
      {required DriverRepo driverResporitory,
      required FirestoreRepo firestoreRepository,
      required StorageRepo storageRepository,
      required User? currentUser})
      : driverRepo = driverResporitory,
        firestoreRepo = firestoreRepository,
        storageRepo = storageRepository,
        user = currentUser,
        super(const AuthenticationState.unknown()) {
    _userSubscription = driverRepo.userStatus.listen((authUser) {
      add(AuthenticationUserChanged(authUser));
    });

    on<AuthenticationUserChanged>((event, emit) async {
      emit(const AuthenticationState.loading());

      try {
        final liveUser = FirebaseAuth.instance.currentUser;

        if (liveUser != null) {
          try {
            await liveUser.reload();
            final reloadedUser = FirebaseAuth.instance.currentUser;

            if (reloadedUser == null) {
              emit(const AuthenticationState.unauthenticated());
            } else {
              // Proceed normally with auth flow
            }
          } catch (e) {
            // Assume user is deleted and sign out
            await FirebaseAuth.instance.signOut();
            emit(const AuthenticationState.unauthenticated());
          }
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
        if (event.driver != null) {
          final uid = event.driver!.uid;
          final progress = await firestoreRepo.getRegistrationProgress(uid);

          if (progress >= 4) {
            final requestStatus = await firestoreRepo.getRequestStatus(uid);

            emit(AuthenticationState.authenticated(
                event.driver!, progress, requestStatus));
          } else {
            emit(
                AuthenticationState.profileIncomplete(event.driver!, progress));
          }
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      } catch (e) {
        emit(const AuthenticationState.unknown());
        log(e.toString());
        rethrow;
      }
    });

    on<SetRegistrationProgress>((event, emit) async {
      final liveUser = FirebaseAuth.instance.currentUser;
      if (liveUser != null) {
        await firestoreRepo.setRegistrationProgress(
            liveUser.uid, event.progress);

        if (event.progress >= 4) {
          final requestStatus =
              await firestoreRepo.getRequestStatus(liveUser.uid);

          emit(AuthenticationState.authenticated(
              liveUser, event.progress, requestStatus));
        } else {
          emit(AuthenticationState.profileIncomplete(liveUser, event.progress));
        }
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });

    on<SetProfileComplete>((event, emit) async {
      await firestoreRepo.setProfileComplete(event.driver!);
    });

    on<DeleteUser>((event, emit) async {
      emit(const AuthenticationState.loading());

      try {
        final liveUser = FirebaseAuth.instance.currentUser;

        if (liveUser != null) {
          final uid = liveUser.uid;

          await firestoreRepo.deleteUser(uid);
          await storageRepo.deleteUserDocument('Driver_Documents_$uid');
          await driverRepo.deleteFirebaseUser(uid);
          await FirebaseAuth.instance.signOut();

          emit(const AuthenticationState.unauthenticated());
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      } catch (e) {
        log('Error during user deletion: $e');
        emit(const AuthenticationState.unknown());
      }
    });
  }
  
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
