import 'package:flut_crack/core/utils/truncate_utils.dart';
import 'package:flut_crack/core/utils/navigation_utils.dart';
import 'package:flut_crack/features/wordlists/presentation/state/word_lists_choice_state_notifier.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WordListChoiceScreen extends HookConsumerWidget {
  const WordListChoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedFilePath = extractArguments<ValueNotifier<String?>>(context);  

    final wordListsState = ref.watch(wordListsNotifierProvider);
    final notifier = ref.read(wordListsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick a wordlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => notifier.filterWordLists(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: wordListsState.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      pickedFilePath.value = wordListsState[index];
                      Navigator.of(context).pop();
                    },
                    child: Text(truncateFileName(wordListsState[index], 25)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
