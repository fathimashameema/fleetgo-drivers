import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final DriverRepo _driverRepository;
  final FirestoreRepo _firestoreRepo;
  SignUpBloc(
      {required DriverRepo driverRepository,
      required FirestoreRepo firestoreRepository})
      : _driverRepository = driverRepository,
        _firestoreRepo = firestoreRepository,
        super(SignUpInitial()) {
    on<SignUpEmail>((event, emit) async {
      emit(SignUpProcess());
      try {
        final Driver driver =
            await _driverRepository.signUpWithEmail(event.driver, event.password);
        await _firestoreRepo.setUserData(driver);
        await _firestoreRepo.deleteOtp(event.mailOrPhone);
        emit(SignUpSuccess());
      } catch (e) {
        log(e.toString());
        emit(SignUpFailure());
      }
    });

    on<SignUpPhone>((event, emit) async {
      emit(SignUpProcess());
      try {
        final Driver user = await _driverRepository.signUpWithPhone(
          event.user,
          event.smsOtp,
        );
        await _firestoreRepo.setUserData(user);
        emit(SignUpSuccess());
      } catch (e) {
        log(e.toString());
        emit(SignUpFailure());
      }
    });

    on<GoogleSignIn>((event, emit) async {
      emit(SignUpProcess());
      try {
        final user = await _driverRepository.signInWithGoogle();
        // setUserData is now handled in the repository for new users only
        emit(SignUpSuccess());
      } catch (e) {
        log(e.toString());
        emit(SignUpFailure());
      }
    });
  }
}
