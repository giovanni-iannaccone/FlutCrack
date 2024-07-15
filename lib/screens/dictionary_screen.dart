import 'package:flutter/material.dart';
import 'package:flut_crack/widgets/nav.dart';
import 'package:flut_crack/utils.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  TextEditingController _wordListNewWordsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _wordListNewWordsController = TextEditingController();
  }

  @override
  void dispose() {
    _wordListNewWordsController.dispose();
    super.dispose();
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
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 100,
              ),
              child: TextField(
                controller: _wordListNewWordsController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your new words',
                ),
              ),
            ),
            
            ElevatedButton(
              onPressed: prepareAddToDictionary,
              child: const Text("Add to the standart wordlist"),
            ),
            const Spacer(),
            const TextButton(
              onPressed: clearDictionary,
              child: Text("Clear wordlist.txt"),
            )
          ],
        ),
      ),
    );
  }

  void prepareAddToDictionary() {
    String newWords = _wordListNewWordsController.text;
    addToDictionary(newWords);

    return;
  }
}