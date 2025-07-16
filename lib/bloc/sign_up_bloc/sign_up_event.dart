part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object?> get props => [];
}

class SignUpEmail extends SignUpEvent {
  final Driver driver;
  final String password;
  final String mailOrPhone;
  const SignUpEmail(this.driver, this.password, this.mailOrPhone);
}

class SignUpPhone extends SignUpEvent {
  final String smsOtp;
  final Driver user;

  const SignUpPhone({required this.user, required this.smsOtp});
}

class GoogleSignIn extends SignUpEvent {
  const GoogleSignIn();
}


