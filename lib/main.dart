import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flut_crack/screens/home_screen.dart';
import 'package:flut_crack/screens/aboutus_screen.dart';
import 'package:flut_crack/screens/dictionary_screen.dart';
import 'package:flut_crack/screens/hash_cracker_screen.dart';

import 'app_routes.dart' as routes;

void main() async {
  runApp(
    const ProviderScope(
      child: FlutCrack()
    )
  );
}

class FlutCrack extends StatelessWidget {
  const FlutCrack({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: routes.home,
      routes: {
        routes.home: (context) => const HomeScreen(),
        routes.hashCracker: (context) => const HashCrackerScreen(),
        routes.dictionary: (context) => const DictionaryScreen(),
        routes.aboutUs: (context) => const AboutUsScreen()
      },
    );
  }
}

