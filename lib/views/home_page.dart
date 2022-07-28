import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlenotes/helpers/loading/loading_screen.dart';
import 'package:littlenotes/services/auth/bloc/auth_bloc.dart';
import 'package:littlenotes/views/login_view.dart';
import 'package:littlenotes/views/notes/forgot_password_view.dart';
import 'package:littlenotes/views/notes/notes_view.dart';
import 'package:littlenotes/views/register_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: ((context, state) {
        //TODO: Fix loading screens breaking the transaction between views
        /*if (state.isLoading && state.exception == null) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Loading...',
          );
        } else {
          LoadingScreen().hide();
        }*/
      }),
      builder: ((context, state) {
        if (state is AuthStateSignedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    'Verification email has been sent. Please verify your account.')));
          });
          return const SignInView();
        } else if (state is AuthStateSignedOut) {
          return const SignInView();
        } else if (state is AuthStateSigningUp) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }
}
