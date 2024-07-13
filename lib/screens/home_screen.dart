import 'package:flutter/material.dart';
import 'package:flut_crack/utils.dart';
import 'package:flut_crack/widgets/nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _hashController = TextEditingController();
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

  final List<String> _wordList = loadDictionary();

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
                  hintText: 'Enter your hash',
                ),
              ),
              DropdownButton(
                items: hashAlgs.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
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
            ],
          )),
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
}
