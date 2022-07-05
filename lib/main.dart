import 'package:flutter/material.dart';
import 'package:littlenotes/views/login_view.dart';
import 'package:littlenotes/views/notes_view.dart';
import 'package:littlenotes/views/register_view.dart';
import 'package:littlenotes/views/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/notes/': ((context) => const NotesView()),
    },
  ));
}
