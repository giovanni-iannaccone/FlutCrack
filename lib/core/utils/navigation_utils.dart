import 'package:flutter/material.dart';

Future<T?> navigateTo<T>(
  BuildContext context, 
  String route, 
  {
    popOldRoutes = false, 
    Object? arguments
  }
){
  final navigator = Navigator.of(context);

  return popOldRoutes
    ? navigator.pushNamedAndRemoveUntil(
        route, 
        (_) => false,
        arguments: arguments
      )
    : navigator.pushNamed(
        route, 
        arguments: arguments
      );
}

T extractArguments<T>(BuildContext context){
  return ModalRoute.of(context)!.settings.arguments as T; 
}