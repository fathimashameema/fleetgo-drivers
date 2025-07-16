part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  profileIncomplete,
  unknown,
  loading
}

class AuthenticationState extends Equatable {
  final User? driver;
  final AuthenticationStatus status;
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.driver,
  });

  const AuthenticationState.unknown() : this._();
  const AuthenticationState.authenticated(User driver)
      : this._(status: AuthenticationStatus.authenticated, driver: driver);
  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
  const AuthenticationState.profileIncomplete(User driver)
      : this._(driver: driver, status: AuthenticationStatus.profileIncomplete);
  const AuthenticationState.loading()
      : this._(status: AuthenticationStatus.loading);

  @override
  List<Object?> get props => [status, driver];
}
