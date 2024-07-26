import 'package:flut_crack/screens/providers/word_list_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DictionaryScreen extends HookConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsTextController = useTextEditingController();
    final wordListManger = ref.watch(wordListManagerProvider);
    final wordListNameController = useTextEditingController();

    final wordListName = ModalRoute.of(context)!.settings.arguments;
    wordListNameController.value = TextEditingValue(text: wordListName.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit wordlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: wordListNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type here the wordlist\'s name',
                prefixIcon: Icon(Icons.spellcheck_sharp),
              ),
              onEditingComplete: () async { 
                wordListManger.renameWordList(wordListName.toString(), wordListNameController.text);
              },
            ),
            const SizedBox(height: 26),
            TextField(
              controller: wordsTextController,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your new words (sepatated by space or comma)',
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final words = wordsTextController.text
                  .split(RegExp("\\s+|\\s*,\\s*"))
                  .map((word) => word.trim())
                  .toList();

                await wordListManger.addWordsToWordList(wordListName.toString(), words);
                wordsTextController.text = '';
              },
              icon: const Icon(Icons.add),
              label: const Text("Add to the wordlist"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
