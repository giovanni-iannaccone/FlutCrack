import 'package:flutter/material.dart';

void navigateTo(
  BuildContext context, String route, 
  {bool shouldPopOldRoutes = false}
){

  final navigator = Navigator.of(context);

  if(shouldPopOldRoutes){
    navigator.pushNamedAndRemoveUntil(
      route, 
      (route) => false
    );
  }else{
    navigator.pushNamed(route);
  }
}