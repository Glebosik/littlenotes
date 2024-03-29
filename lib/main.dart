import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlenotes/constatnts/routes.dart';
import 'package:littlenotes/services/auth/bloc/auth_bloc.dart';
import 'package:littlenotes/services/auth/firebase_auth_provider.dart';
import 'package:littlenotes/views/notes/create_update_note_view.dart';
import 'package:littlenotes/views/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: ((context) => const CreateUpdateNoteView()),
    },
  ));
}
