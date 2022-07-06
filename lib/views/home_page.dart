import 'package:flutter/material.dart';
import 'package:littlenotes/services/auth/auth_service.dart';
import 'package:littlenotes/views/login_view.dart';
import 'package:littlenotes/views/notes_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return FutureBuilder(
                    future: AuthService.firebase().sendEmailVerification(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Verification email has been sent. Please verify your account.')));
                          });
                          return const LoginView();
                        default:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    });
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
