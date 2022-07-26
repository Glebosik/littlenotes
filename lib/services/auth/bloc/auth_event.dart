part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventSignIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventSignIn(this.email, this.password);
}

class AuthEventShouldSignUp extends AuthEvent {
  const AuthEventShouldSignUp();
}

class AuthEventSignUp extends AuthEvent {
  final String email;
  final String password;
  const AuthEventSignUp(this.email, this.password);
}

class AuthEventSignOut extends AuthEvent {
  const AuthEventSignOut();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
