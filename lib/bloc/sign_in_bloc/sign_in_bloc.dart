import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final DriverRepo _driverRepo;
  SignInBloc({required DriverRepo driverRepository})
      : _driverRepo = driverRepository,
        super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      log('sign in requiured executed');
      try {
        final errorMessage =
            await _driverRepo.signIn(event.identifier, event.password);
        if (errorMessage != null) {
          emit(SignInFailure(message: errorMessage));
        } else {
          emit(SignInSuccess());
        }
      } catch (e) {
        log(e.toString());
        emit(const SignInFailure(
            message: 'An unknown error occured.Please try again.'));
      }
    });

    on<SignOutRequired>((event, emit) async {
      try {
        await _driverRepo.logoOut();
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
