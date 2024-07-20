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
  String _file = "Pick a wordlist";
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
    List<String> wordList = await FileStorage.loadDictionary(filePath);

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
        setState(() {
          _file = result.files.first.path!;
        });

        File filePath = File(_file);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _hashController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your hash',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Hash Algorithm',
              ),
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
            const SizedBox(height: 16),
            _result.isEmpty 
              ? const Text("Enter a hash to start", style: TextStyle(color: Colors.grey))
              : Text(_result, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            const Spacer(),
            _triedWords == 0 
              ? const SizedBox.shrink()
              : Text("$_triedWords words tried", style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _pickWordlist,
              icon: const Icon(Icons.folder_open),
              label: Text(_file),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 20),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crack,
        child: const Icon(Icons.vpn_key),
      ),
    );
  }
}
