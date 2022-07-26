import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:littlenotes/services/auth/auth_provider.dart';
import 'package:littlenotes/services/auth/auth_user.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateSignedOut(null, false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateSignedIn(user));
      }
    });
    on<AuthEventSignIn>(((event, emit) async {
      emit(const AuthStateSignedOut(null, true));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.signIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateSignedOut(null, false));
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification());
        } else {
          emit(const AuthStateSignedOut(null, false));
          emit(AuthStateSignedIn(user));
        }
        emit(AuthStateSignedIn(user));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(e, false));
      }
    }));
    on<AuthEventSignUp>(((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateSigningUp(e));
      }
    }));
    on<AuthEventSignOut>(((event, emit) async {
      try {
        await provider.signOut();
        emit(const AuthStateSignedOut(null, false));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(e, false));
      }
    }));
    on<AuthEventShouldSignUp>(((event, emit) {
      emit(const AuthStateSigningUp(null));
    }));
  }
}
