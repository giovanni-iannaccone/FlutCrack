import 'package:flutter/material.dart';

Future<T?> navigateTo<T>(
  BuildContext context, 
  String route, 
  {
    popOldRoutes = false, 
    Object? arguments
  }
) async {
  final navigator = Navigator.of(context);

  return popOldRoutes
    ? await navigator.pushNamedAndRemoveUntil(
        route, 
        (_) => false,
        arguments: arguments
      )
    : await navigator.pushNamed(
        route, 
        arguments: arguments
      );
}

T extractArguments<T>(BuildContext context){
  return ModalRoute.of(context)!.settings.arguments as T; 
}