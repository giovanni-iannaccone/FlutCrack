import 'package:flutter/material.dart';
import 'theme_utils.dart' show colorSchemeOf;

void _showSnackBar(BuildContext context, String message, [bool isError = false]){
  final colorScheme = colorSchemeOf(context);

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(10),
        elevation: 2,
        showCloseIcon: true,
        closeIconColor: isError ? colorScheme.onError : null,
        backgroundColor: isError ? colorScheme.error : null,
        content: Text(
          message,
          style: TextStyle(
              color: isError ? colorScheme.onError : null
          )
        )
      )
  );
}

void showSnackBar(BuildContext context, String message){
  _showSnackBar(context, message);
}

void showErrorSnackBar(BuildContext context, String message){
  _showSnackBar(context, message, true);
}