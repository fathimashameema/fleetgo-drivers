part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
  @override
  List<Object?> get props => [];
}

class SignInRequired extends SignInEvent {
  final String identifier;
  final String password;

  const SignInRequired(this.identifier, this.password);
}

class SignOutRequired extends SignInEvent {
  const SignOutRequired();
}
