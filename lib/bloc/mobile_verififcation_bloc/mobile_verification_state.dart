part of 'mobile_verification_bloc.dart';

abstract class MobileVerificationState extends Equatable {
  const MobileVerificationState();

  @override
  List<Object> get props => [];
}

class MobileVerificationInitial extends MobileVerificationState {}

class MobileVerificationLoading extends MobileVerificationState {}

class MobileVerificationSuccess extends MobileVerificationState {}

class MobileVerificationFailure extends MobileVerificationState {}
