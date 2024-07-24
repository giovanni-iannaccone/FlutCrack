import 'package:flutter/material.dart';

void navigateTo(BuildContext context, String route, {popOldRoutes = false}){
  final navigator = Navigator.of(context);

  if(popOldRoutes){
    navigator.pushNamedAndRemoveUntil(
      route, 
      (_) => false
    );
  } else {
    navigator.pushNamed(route);
  }
}