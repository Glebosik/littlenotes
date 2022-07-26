import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

@Deprecated(
    'It is not a good idea to use Navigator.pop() with a loading dialog. It is possible to pop something in the navigator stack you should not pop')
CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10,
        ),
        Text(text),
      ],
    ),
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );
  return () => Navigator.of(context).pop();
}
