import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flut_crack/utils/checks_utils.dart';
import 'package:flut_crack/utils/files_utils.dart';
import 'package:flut_crack/utils/hash_utils.dart';
import 'package:flut_crack/widgets/nav.dart';

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
  int _triedWords = 0;

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

  Future<void> _initializeWordList(File? filePath) async {
    List<String> wordList = filePath != null
        ? await FileStorage.loadDictionary(filePath)
        : await FileStorage.loadDictionary(File("/storage/emulated/0/Download/wordlist.txt"));

    setState(() {
      _wordList = wordList;
    });
  }

  Future<void> _pickWordlist() async {
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
      return;
    }
  }

  Future<void> _crack() async {
    String targetHash = _hashController.text.trim();
    
    if (_wordList.isEmpty) {
      await _initializeWordList(null);
    }

    if (_wordList.isEmpty) {
      _updateState(result: 'Wordlist is empty', triedWords: 0);
      return;
    }

    String safeExecutorResult = await safeExecuter(_wordList, _dropdownValue, targetHash);

    if (isAlgorithmUnknown(safeExecutorResult)) {
      _updateState(result: safeExecutorResult, triedWords: 0);
      return;
    }

    String algorithm = determineAlgorithm(safeExecutorResult, _dropdownValue);
    await _performCracking(targetHash, algorithm);
  }

  Future<void> _performCracking(String targetHash, String algorithm) async {
    for (String word in _wordList) {
      String wordHash = calcHash(word, algorithm);

      if (wordHash == targetHash) {
        _updateState(result: 'Match found: $word', triedWords: 0);
        return;
      }

      setState(() {
        _triedWords += 1;
      });
    }

    _updateState(result: 'No match found', triedWords: 0);
  }

  void _updateState({required String result, required int triedWords}) {
    setState(() {
      _result = result;
      _triedWords = triedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("FlutCrack"),
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
            _result.isEmpty ? const Text("Enter a hash to start") : Text(_result),
            const Spacer(),
            _triedWords == 0 ? const Text("") : Text("$_triedWords words tried"),
            const Spacer(),
            TextButton(
              onPressed: _pickWordlist,
              child: const Text("Pick a wordlist"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crack,
        child: const Icon(Icons.key_off),
      ),
    );
  }
}
