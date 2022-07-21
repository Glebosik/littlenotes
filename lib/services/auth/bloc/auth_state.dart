part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateSignedIn extends AuthState {
  final AuthUser user;
  const AuthStateSignedIn(this.user);
}

class AuthStateSigningUp extends AuthState {
  final Exception? exception;
  const AuthStateSigningUp(this.exception);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateSignedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateSignedOut(this.exception, this.isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}
