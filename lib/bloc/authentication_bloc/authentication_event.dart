part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  final User? driver;

  const AuthenticationUserChanged(this.driver);
}

class SetProfileComplete extends AuthenticationEvent {
  final Driver? driver;

  const SetProfileComplete(this.driver);
}

class SetRegistrationProgress extends AuthenticationEvent {
  final int progress;

  const SetRegistrationProgress(this.progress);

  @override
  List<Object> get props => [progress];
}
