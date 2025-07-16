part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendResetCodeRequested extends ForgotPasswordEvent {
  final String identifier;
  final String message;
  const SendResetCodeRequested(this.identifier, this.message);

  @override
  List<Object?> get props => [identifier, message];
}

class VerifyResetCode extends ForgotPasswordEvent {
  final String code;
  final String? email;
  final String? phone;

  const VerifyResetCode(this.code, {this.email, this.phone});

  @override
  List<Object?> get props => [code, email, phone];
}

class PasswordResetRequested extends ForgotPasswordEvent {
  final String newPassword;
  final String? currentPassword;
  final String? email;
  final String? phone;

  const PasswordResetRequested(this.newPassword, {
    this.currentPassword,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [newPassword, currentPassword, email, phone];
}

class VerifyCurrentPassword extends ForgotPasswordEvent {
  final String currentPassword;
  final String? email;
  final String? phone;
  const VerifyCurrentPassword(this.currentPassword, {this.email, this.phone});

  @override
  List<Object?> get props => [currentPassword, email, phone];
}
