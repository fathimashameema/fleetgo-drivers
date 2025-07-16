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
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc(
      {required DriverRepo driverResporitory,
      required FirestoreRepo firestoreRepository})
      : driverRepo = driverResporitory,
        firestoreRepo = firestoreRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = driverRepo.userStatus.listen((authUser) {
      add(AuthenticationUserChanged(authUser));
    });

    on<AuthenticationUserChanged>((event, emit) async {
      emit(const AuthenticationState.loading());
      try {
        if (event.driver != null) {
          final isProfileComplete =
              await firestoreRepo.isProfileComplete(event.driver!);
          if (isProfileComplete) {
            emit(AuthenticationState.authenticated(event.driver!));
          } else {
            emit(AuthenticationState.profileIncomplete(event.driver!));
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
