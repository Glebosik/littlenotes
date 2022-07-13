import 'package:flutter/material.dart';
import 'package:littlenotes/constatnts/routes.dart';
import 'package:littlenotes/views/login_view.dart';
import 'package:littlenotes/views/notes/create_update_note_view.dart';
import 'package:littlenotes/views/notes/notes_view.dart';
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
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: ((context) => const NotesView()),
      createOrUpdateNoteRoute: ((context) => const CreateUpdateNoteView()),
    },
  ));
}
