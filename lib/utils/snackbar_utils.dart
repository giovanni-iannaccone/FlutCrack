import 'package:flutter/material.dart';
import 'theme_utils.dart' show colorSchemeOf;

void showErrorSnackBar(BuildContext context, String error){
  final colorScheme = colorSchemeOf(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(10),
      elevation: 2,
      showCloseIcon: true,
      closeIconColor: colorScheme.onError,
      backgroundColor: colorScheme.error,
      content: Text(
        error, 
        style: TextStyle(
          color: colorScheme.onError
        )
      )
    )
  );
}