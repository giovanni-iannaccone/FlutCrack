import 'package:flut_crack/screens/providers/word_list_manager_provider.dart';
import 'package:flut_crack/utils/theme_utils.dart' show colorSchemeOf;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DictionaryScreen extends HookConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colorScheme = colorSchemeOf(context);
    final wordsTextController = useTextEditingController();
    final wordListManger = ref.watch(wordListManagerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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

                await wordListManger.addWordsToDefaultWordList(words);
                wordsTextController.text = '';
              },
              icon: const Icon(Icons.add),
              label: const Text("Add to the standard wordlist"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: wordListManger.clearDefaultWordList,
              icon: const Icon(Icons.clear),
              label: const Text("Clear the standard wordlist."),
              style: ElevatedButton.styleFrom(
                iconColor: colorScheme.error
              ),
            ),
          ],
        ),
      ),
    );
  }

}
