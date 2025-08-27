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
  final User? user;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc(
      {required DriverRepo driverResporitory,
      required FirestoreRepo firestoreRepository,
      required User? currentUser})
      : driverRepo = driverResporitory,
        firestoreRepo = firestoreRepository,
        user = currentUser,
        super(const AuthenticationState.unknown()) {
    _userSubscription = driverRepo.userStatus.listen((authUser) {
      add(AuthenticationUserChanged(authUser));
    });

    // on<AuthenticationUserChanged>((event, emit) async {
    //   emit(const AuthenticationState.loading());
    //   try {
    //     if (event.driver != null) {
    //       final isProfileComplete =
    //           await firestoreRepo.isProfileComplete(event.driver!);
    //       if (isProfileComplete) {
    //         emit(AuthenticationState.authenticated(event.driver!));
    //       } else {
    //         emit(AuthenticationState.profileIncomplete(event.driver!));
    //       }
    //     } else {
    //       emit(const AuthenticationState.unauthenticated());
    //     }
    //   } catch (e) {
    //     emit(const AuthenticationState.unknown());
    //     log(e.toString());
    //     rethrow;
    //   }
    // });

    on<AuthenticationUserChanged>((event, emit) async {
      emit(const AuthenticationState.loading());

      try {
        if (event.driver != null) {
          final uid = event.driver!.uid;
          final progress = await firestoreRepo.getRegistrationProgress(uid);

          if (progress >= 4) {
            emit(AuthenticationState.authenticated(event.driver!, progress));
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

        // Re-emit updated state
        if (event.progress >= 4) {
          emit(AuthenticationState.authenticated(liveUser, event.progress));
        } else {
          emit(AuthenticationState.profileIncomplete(
              liveUser, event.progress));
        }
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });

    on<SetProfileComplete>((event, emit) async {
      await firestoreRepo.setProfileComplete(event.driver!);
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
