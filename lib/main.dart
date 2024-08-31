import 'package:flut_crack/features/hashing/presentation/hasher_screen.dart';
import 'package:flut_crack/features/wordlists/presentation/word_lists_screen.dart';
import 'package:flut_crack/features/wordlists/presentation/word_list_choice_screen.dart';
import 'package:flut_crack/features/wordlists/presentation/network_word_list_choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flut_crack/features/hashing/presentation/home_screen.dart';
import 'package:flut_crack/features/about/presentation/aboutus_screen.dart';
import 'package:flut_crack/features/wordlists/presentation/edit_word_list_screen.dart';
import 'package:flut_crack/features/hashing/presentation/hash_cracker_screen.dart';

import 'app_routes.dart' as routes;

void main() {
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
        routes.about: (context) => const AboutUsScreen(),
        routes.editWordList: (context) => const EditWordListScreen(),
        routes.hashCracker: (context) => const HashCrackerScreen(),
        routes.hasher: (context) => const HasherScreen(),
        routes.home: (context) => const HomeScreen(),
        routes.manageWordLists: (context) => const WordListsScreen(),
        routes.networkWordListChoice: (context) => const NetworkWordListChoiceScreen(),
        routes.wordListChoice: (context) => const WordListChoiceScreen()
      },
    );
  }
}

