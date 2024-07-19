import 'package:flutter/material.dart';

import 'package:flut_crack/screens/aboutus_screen.dart';
import 'package:flut_crack/screens/dictionary_screen.dart';
import 'package:flut_crack/screens/home_screen.dart';

import 'app_routes.dart' as routes;

void main() async {
  runApp(const FlutCrack());
}

class FlutCrack extends StatelessWidget {
  const FlutCrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      routes: {
        routes.home: (context) => const HomeScreen(),
        routes.dictionary: (context) => const DictionaryScreen(),
        routes.credits: (context) => const AboutUsScreen()
      },
    );
  }
}

