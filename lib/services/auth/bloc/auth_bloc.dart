import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:littlenotes/services/auth/auth_provider.dart';
import 'package:littlenotes/services/auth/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateSignedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateSignedIn(
          user: user,
          isLoading: false,
        ));
      }
    });
    on<AuthEventSignIn>(((event, emit) async {
      emit(const AuthStateSignedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Signing in...',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.signIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateSignedOut(
            exception: null,
            isLoading: false,
          ));
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateSignedOut(
            exception: null,
            isLoading: false,
          ));
          emit(AuthStateSignedIn(
            user: user,
            isLoading: false,
          ));
        }
        emit(AuthStateSignedIn(
          user: user,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(
          exception: e,
          isLoading: false,
        ));
      }
    }));
    on<AuthEventSignUp>(((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateSigningUp(exception: e, isLoading: false));
      }
    }));
    on<AuthEventSignOut>(((event, emit) async {
      try {
        await provider.signOut();
        emit(const AuthStateSignedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(
          exception: e,
          isLoading: false,
        ));
      }
    }));
    on<AuthEventShouldSignUp>(((event, emit) {
      emit(const AuthStateSigningUp(
        exception: null,
        isLoading: false,
      ));
    }));
  }
}
