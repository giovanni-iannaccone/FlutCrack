import 'package:flutter/material.dart';
import 'package:flut_crack/widgets/nav.dart';
import 'package:flut_crack/utils/files_utils.dart';

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
        title: const Text("Dictionary Management"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _wordListNewWordsController,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your new words',
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: prepareAddToDictionary,
              icon: const Icon(Icons.add),
              label: const Text("Add to the standard wordlist"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: FileStorage.clearDictionary,
              icon: const Icon(Icons.clear),
              label: const Text("Clear wordlist.txt"),
              style: ElevatedButton.styleFrom(
                iconColor: Theme.of(context).colorScheme.error,
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void prepareAddToDictionary() {
    String newWords = _wordListNewWordsController.text;
    FileStorage.writeNewWords(newWords);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("New words added to the dictionary")),
    );
  }
}
