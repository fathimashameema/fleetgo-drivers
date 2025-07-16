part of 'mobile_verification_bloc.dart';

abstract class MobileVerificationEvent extends Equatable {
  const MobileVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyPhone extends MobileVerificationEvent {
  final String phone;
  // final Function(String verificationId) navigate;
  const VerifyPhone(this.phone);
}
