part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  profileIncomplete,
  unknown,
  loading,
}

class AuthenticationState extends Equatable {
  final User? driver;
  final AuthenticationStatus status;
  final int registrationProgress;
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.driver,
    this.registrationProgress = 0,
  });

  const AuthenticationState.unknown() : this._();
  const AuthenticationState.authenticated(
    User driver,
    int progress,
  ) : this._(
            status: AuthenticationStatus.authenticated,
            driver: driver,
            registrationProgress: progress);
  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
  const AuthenticationState.profileIncomplete(User driver,int progress )
      : this._(driver: driver, status: AuthenticationStatus.profileIncomplete,registrationProgress: progress);
  const AuthenticationState.loading()
      : this._(status: AuthenticationStatus.loading);

  @override
  List<Object?> get props => [status, driver,registrationProgress];
}
