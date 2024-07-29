import 'package:flut_crack/core/utils/navigation_utils.dart';
import 'package:flut_crack/core/utils/snackbar_utils.dart';
import 'package:flut_crack/features/wordlists/presentation/state/edit_word_list_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditWordListScreen extends HookConsumerWidget {
  const EditWordListScreen({super.key});

  void _handleState(BuildContext context, EditScreenState state) {
    switch(state){
      case EditScreenState.renameSuccess:
        showSnackBar(context, "Word list renamed correctly.");
        break;
      case EditScreenState.renameFail:
        showErrorSnackBar(context, "Unable to rename this word list.");
        break;
      case EditScreenState.appendWordsSuccess:
        showSnackBar(context, "Words appended to this word list.");
        break;
      case EditScreenState.appendWordsFail:
        showErrorSnackBar(context, "Unable to append new words to this word list.");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final wordListName = extractArguments<String>(context);  

    final wordsTextController = useTextEditingController();
    final wordListNameController = useTextEditingController(text: wordListName);

    final notifier = ref.read(editWordListScreenNotifierProvider.notifier);

    ref.listen<EditScreenState>(
      editWordListScreenNotifierProvider,
      (_, state) => _handleState(context, state)
    );

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
                labelText: "Type here the wordlist's name",
                prefixIcon: Icon(Icons.spellcheck_sharp),
              ),
              onEditingComplete: () => notifier.renameWordList(
                wordListName,
                wordListNameController.text.trim()
              ),
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
              onPressed: () {

                final words = wordsTextController.text
                  .split(RegExp("\\s+|\\s*,\\s*"))
                  .map((word) => word.trim())
                  .toList();

                wordsTextController.text = '';

                notifier.appendWordsToWordList(wordListName, words);
              },
              icon: const Icon(Icons.add),
              label: const Text("Add to the wordlist"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
          ],
        ),
      )
    );
  }

}
