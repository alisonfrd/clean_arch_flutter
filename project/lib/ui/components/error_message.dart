import 'package:flutter/material.dart';

void showErrorMensage(BuildContext context, String error) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(error),
    ),
  );
}
