part of 'email_verification_bloc.dart';

sealed class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtp extends EmailVerificationEvent {
  final String mailOrPhone;
  final int otp;
  const VerifyOtp({required this.mailOrPhone, required this.otp});
}

class ResentOtp extends EmailVerificationEvent {
  final String mailOrPhone;
  final int otp;
  final String message;

  const ResentOtp({
    required this.otp,
    required this.mailOrPhone,
    required this.message,
  });
}

class VerifyEmail extends EmailVerificationEvent {
  final String email;
  final int otp;
  final String message;

  const VerifyEmail({
    required this.otp,
    required this.email,
    required this.message,
  });
}
