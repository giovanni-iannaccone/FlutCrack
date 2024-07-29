import 'package:flut_crack/features/hashing/presentation/hash_cracker_screen.dart';
import 'package:flut_crack/features/hashing/presentation/hasher_screen.dart';
import 'package:flut_crack/features/wordlists/presentation/word_lists_screen.dart';
import 'package:flut_crack/core/utils/navigation_utils.dart';
import 'package:flut_crack/app_routes.dart' as routes;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class HomeScreen extends HookWidget { 

  const HomeScreen({super.key});  

  @override 
  Widget build(BuildContext context) { 

    const List<Widget> screens = [  
      WordListsScreen(),
      HashCrackerScreen(),
      HasherScreen()
    ];

    final pageIndex = useState(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("FlutCrack"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () => navigateTo(context, routes.about),
            icon: const Icon(Icons.question_mark)
          )
        ],
      ),
      body: screens[pageIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Wordlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Hasher',
          ),
        ],
        currentIndex: pageIndex.value,
        selectedItemColor: Colors.blue,
        onTap: (index) => pageIndex.value = index,
      ),
    ); 
  } 
}