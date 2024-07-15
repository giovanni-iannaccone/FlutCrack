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
    'md5',
    'base64',
    'sha-1',
    'sha-224',
    'sha-256',
    'sha-512',
  ];

  String _dropdownValue = 'md5';
  String _result = "";
  List<String> _wordList = [];

  @override
  void initState() {
    super.initState();
    _hashController = TextEditingController();
  }

  Future<void> _initializeWordList(File filePath) async {
    List<String> wordList = await loadDictionary(filePath);

    setState(() {
      _wordList = wordList;
    });
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

  void crack() {
    String targetHash = _hashController.text.trim();
    String wordHash;

    for (String word in _wordList) {
      wordHash = calcHash(word, _dropdownValue);

      if (wordHash == targetHash) {
        setState(() {
          _result = 'Match found: $word';
        });
        return;
      }
    }

    setState(() {
      _result = 'No match found';
    });
  }

  void pickWordlist() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      File filePath = File(result.files.first.path!);
      await _initializeWordList(filePath);
    }
  }
}
