import 'package:flut_crack/screens/aboutus_screen.dart';
import 'package:flut_crack/screens/dictionary_screen.dart';
import 'package:flut_crack/screens/hash_cracker_screen.dart';
import 'package:flut_crack/screens/hasher_screen.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget { 
  const HomeScreen({super.key});
  
  @override 
  State<HomeScreen> createState() => _HomeScreenState(); 
} 
  
class _HomeScreenState extends State<HomeScreen> { 
  int _selectedIndex = 1;

  Map<int, Widget> routesMap = {
    0: const DictionaryScreen(),
    1: const HashCrackerScreen(),
    2: const HasherScreen(),
    3: const AboutUsScreen()
  };

  _onItemTapped(int index) {
    setState(() {
      if (index != 3) {
        _selectedIndex = index;
      }
    });
  }

  @override 
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlutCrack"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              _onItemTapped(3);
            },
            icon: const Icon(Icons.question_mark)
          )
        ],
      ),

      body: routesMap[_selectedIndex],

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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    ); 
  } 
}