import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:littlenotes/firebase_options.dart';
import 'package:littlenotes/views/login_view.dart';
import 'package:littlenotes/views/notes_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              user.reload();
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return FutureBuilder(
                    future: user.sendEmailVerification(),
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
