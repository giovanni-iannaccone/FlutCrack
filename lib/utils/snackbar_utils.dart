import 'package:flutter/material.dart';
import 'theme_utils.dart' show colorSchemeOf;

void _showSnackBar(BuildContext context, String message, {bool error = false}){
  final colorScheme = colorSchemeOf(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(10),
      elevation: 2,
      showCloseIcon: true,
      closeIconColor: error ? colorScheme.onError : null,
      backgroundColor: error ? colorScheme.error : null,
      content: Text(
        message, 
        style: TextStyle(
          color: error ? colorScheme.onError : null
        )
      )
    )
  );
}

void showErrorSnackBar(BuildContext context, String message){
  _showSnackBar(context, message, error: true);
}

void showSnackBar(BuildContext context, String message){
  _showSnackBar(context, message);
}