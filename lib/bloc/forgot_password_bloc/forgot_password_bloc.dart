import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final DriverRepo driverRepository;
  final FirestoreRepo firestoreRepo;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ForgotPasswordBloc(
      {required this.driverRepository, required this.firestoreRepo})
      : super(ForgotPasswordInitial()) {
    on<SendResetCodeRequested>(_onSendResetCodeRequested);
    on<VerifyResetCode>(_onVerifyResetCode);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onSendResetCodeRequested(
    SendResetCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(event.identifier)) {
        final userId = await firestoreRepo.getUserId(event.identifier);
        if (userId == null) {
          emit(const ForgotPasswordFailure(
              error: 'No user found with this email'));
          return;
        }

        final otp = _generateOtp();
        await firestoreRepo.setOtp(otp, event.identifier);
        await driverRepository.verifyEmail(event.identifier, otp, event.message);

        emit(ResetCodeSent(email: event.identifier));
      } else if (RegExp(r'^[0-9]{10}$').hasMatch(event.identifier)) {
        final isPhoneExist = await firestoreRepo.isPhoneExit(event.identifier);
        if (!isPhoneExist) {
          emit(const ForgotPasswordFailure(
              error: 'No user found with this mobile number'));
          return;
        }
        await driverRepository.verifyPhone(event.identifier);
        emit(ResetCodeSent(phone: event.identifier));
      } else {
        final email = await firestoreRepo.getEmailWithName(event.identifier);
        if (email == null) {
          emit(const ForgotPasswordFailure(
              error: 'No user found with this username'));
          return;
        }

        final otp = _generateOtp();
        await firestoreRepo.setOtp(otp, email);
        await driverRepository.verifyEmail(email, otp, event.message);

        emit(ResetCodeSent(email: email));
      }
    } catch (e) {
      emit(ForgotPasswordFailure(
          error: 'Failed to send verification code: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyResetCode(
    VerifyResetCode event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      bool isValid = false;

      if (event.email != null) {
        final storedOtp = await firestoreRepo.getOtp(event.email!);
        isValid = storedOtp.toString() == event.code;
      } else if (event.phone != null) {
        isValid = await driverRepository.verifySmsCodeForReset(event.code);
      }

      if (isValid) {
        emit(ResetCodeVerified(
          email: event.email,
          phone: event.phone,
        ));
      } else {
        emit(const ForgotPasswordFailure(error: 'Invalid verification code'));
      }
    } catch (e) {
      emit(
          ForgotPasswordFailure(error: 'Verification failed: ${e.toString()}'));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      String? userId;
      String? email;

      if (event.email != null) {
        userId = await firestoreRepo.getUserId(event.email!);
        email = event.email;
      } else if (event.phone != null) {
        final userQuery = await FirebaseFirestore.instance
            .collection('driver')
            .where('number', isEqualTo: event.phone!)
            .limit(1)
            .get();

        if (userQuery.docs.isNotEmpty) {
          userId = userQuery.docs.first.id;
          email = userQuery.docs.first.data()['email'];
        }
      }

      if (userId == null || email == null) {
        emit(const ForgotPasswordFailure(error: 'Driver not found'));
        return;
      }

      // Verify current password by attempting to sign in
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: event.currentPassword!,
        );
      } catch (e) {
        emit(const ForgotPasswordFailure(error: 'Current password is incorrect'));
        return;
      }

      // Update password
      await driverRepository.updatePassword(userId, event.newPassword);

      emit(PasswordResetSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure(
          error: 'Password reset failed: ${e.toString()}'));
    }
  }

  int _generateOtp() {
    return 100000 + Random().nextInt(900000); // 6-digit OTP
  }
}
