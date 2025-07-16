part of 'password_visibility_bloc.dart';

abstract class PasswordVisibilityEvent extends Equatable {
  const PasswordVisibilityEvent();

  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibility extends PasswordVisibilityEvent {
  final String fieldId;

  const TogglePasswordVisibility(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}

class ResetPasswordVisibility extends PasswordVisibilityEvent {
  final String fieldId;

  const ResetPasswordVisibility(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}
