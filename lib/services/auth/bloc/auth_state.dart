part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  final Exception? exception;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Loading...',
    this.exception,
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateSignedIn extends AuthState {
  final AuthUser user;
  const AuthStateSignedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateSigningUp extends AuthState {
  const AuthStateSigningUp({
    required bool isLoading,
    Exception? exception,
  }) : super(isLoading: isLoading, exception: exception);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateSignedOut extends AuthState with EquatableMixin {
  const AuthStateSignedOut({
    required bool isLoading,
    String? loadingText,
    Exception? exception,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
          exception: exception,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateForgotPassword extends AuthState with EquatableMixin {
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required this.hasSentEmail,
    required bool isLoading,
    Exception? exception,
  }) : super(isLoading: isLoading, exception: exception);

  @override
  List<Object?> get props => [exception, hasSentEmail, isLoading];
}
