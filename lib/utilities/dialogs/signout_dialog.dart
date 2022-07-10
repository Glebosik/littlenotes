import 'package:flutter/cupertino.dart';
import 'package:littlenotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showSignOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sign out',
    content: 'Are you sure you want to sign out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Sign out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
