part of 'email_verification_bloc.dart';

abstract class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object> get props => [];
}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}

class EmailVerificationFailure extends EmailVerificationState {
  final String error;

  const EmailVerificationFailure({required this.error});
}
