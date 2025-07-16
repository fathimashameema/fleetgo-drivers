part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;
  const ForgotPasswordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class ResetCodeSent extends ForgotPasswordState {
  final String? email;
  final String? phone;
  const ResetCodeSent({this.email, this.phone});

  @override
  List<Object?> get props => [email, phone];
}

class ResetCodeVerified extends ForgotPasswordState {
  final String? email;
  final String? phone;
  const ResetCodeVerified({this.email, this.phone});

  @override
  List<Object?> get props => [email, phone];
}

class PasswordResetSuccess extends ForgotPasswordState {}

// class CurrentPasswordVerified extends ForgotPasswordState {}

// class CurrentPasswordVerificationFailed extends ForgotPasswordState {
//   final String error;
//   const CurrentPasswordVerificationFailed({required this.error});

//   @override
//   List<Object?> get props => [error];
// }
