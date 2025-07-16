import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final FirestoreRepo _firestoreRepo;
  final DriverRepo _driverRepo;
  EmailVerificationBloc(
      {required FirestoreRepo firestoreRepository,
      required DriverRepo driverRepository})
      : _firestoreRepo = firestoreRepository,
        _driverRepo = driverRepository,
        super(EmailVerificationInitial()) {
    on<VerifyOtp>((event, emit) async {
      emit(EmailVerificationLoading());
      try {
        final otpStored = await _firestoreRepo.getOtp(event.mailOrPhone);
        if (otpStored != null && otpStored == event.otp) {
          emit(EmailVerificationSuccess());
        } else if (otpStored == null) {
          emit(const EmailVerificationFailure(error: 'otp is null'));
        } else {
          emit(const EmailVerificationFailure(error: 'Incorrect OTP'));
        }
      } catch (e) {
        log(e.toString());
        emit(const EmailVerificationFailure(
            error: 'Something went wrong, Please try again'));
      }
    });

    on<ResentOtp>((event, emit) async {
      try {
        await _driverRepo.verifyEmail(
            event.mailOrPhone, event.otp, event.message);

        await _firestoreRepo.resetOtp(event.mailOrPhone, event.otp);

        // emit(EmailVerificationLoading());
      } catch (e) {
        log(e.toString());
        emit(const EmailVerificationFailure(
            error: 'Something went wrong, Please try again'));
      }
    });

    on<VerifyEmail>((event, emit) async {
      try {
        await _driverRepo.verifyEmail(event.email, event.otp, event.message);
        await _firestoreRepo.setOtp(
          event.otp,
          event.email,
        );
        // emit(EmailVerificationLoading());
      } catch (e) {
        log(e.toString());
        emit(const EmailVerificationFailure(
            error: 'Something went wrong, Please try again'));
      }
    });
  }
}
