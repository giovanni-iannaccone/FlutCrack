import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flut_crack/utils.dart';
import 'package:flut_crack/widgets/nav.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _hashController;
  final List<String> hashAlgs = [
    'Unknown',
    'md5',
    'sha-1',
    'sha-224',
    'sha-256',
    'sha-384',
    'sha-512',
    'sha-512/224',
    'sha-512/256'
  ];

  String _dropdownValue = 'Unknown';
  String _result = "";
  List<String> _wordList = [];
  int _tryiedWords = 0;

  Future<void> _initializeWordList(File? filePath) async {
    List<String> wordList;

    filePath != null
      ? wordList = await FileStorage.loadDictionary(filePath)
      : wordList = await FileStorage.loadDictionary(File("/storage/emulated/0/Download/wordlist.txt"));

    setState(() {
      _wordList = wordList;
    });
  }

  @override
  void initState() {
    super.initState();
    _hashController = TextEditingController();
  }

  @override
  void dispose() {
    _hashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          "FlutCrack",
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        margin: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: _hashController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your hash',
              ),
            ),
            DropdownButton<String>(
              items: hashAlgs.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _dropdownValue = newValue!;
                });
              },
              value: _dropdownValue,
            ),
            _result.isEmpty
                ? const Text("Enter a hash to start")
                : Text(_result),
            const Spacer(),
            _tryiedWords == 0
              ? const Text("")
              : Text("$_tryiedWords words tryed"),

            const Spacer(),
            TextButton(
              onPressed: pickWordlist,
              child: const Text("Pick a wordlist"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crack,
        child: const Icon(Icons.key_off),
      ),
    );
  }

  void crack() async {
    String algorithm;
    String targetHash = _hashController.text.trim();
    String wordHash;
    String safeExecuterResult = await safeExecuter(_wordList, _dropdownValue, targetHash);

    if ( safeExecuterResult == "" ) {
      await _initializeWordList(null);

    } else if ( safeExecuterResult == "Unable to identify the algorithm" ) {
       _result = safeExecuterResult;

    } else {
      safeExecuterResult == "true"
      ? algorithm = _dropdownValue
      : algorithm = safeExecuterResult;

      for (String word in _wordList) {
        wordHash = calcHash(word, algorithm);
        
        setState(() {
          _tryiedWords += 1;
        });

        if (wordHash == targetHash) {
          setState(() {
            _tryiedWords = 0;
            _result = 'Match found: $word';
          });
          return;
        }
      }

      _result = 'No match found';
    }

    setState(() {
      _tryiedWords = 0;
    });
  }

  void pickWordlist() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        File filePath = File(result.files.first.path!);
        await _initializeWordList(filePath);
      }
    } catch (e) {
      return ;
    }
  }
}
