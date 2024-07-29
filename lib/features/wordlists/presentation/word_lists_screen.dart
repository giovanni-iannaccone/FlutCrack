import 'package:flut_crack/core/utils/navigation_utils.dart';
import 'package:flut_crack/core/utils/snackbar_utils.dart';
import 'package:flut_crack/features/wordlists/presentation/state/word_lists_screen_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flut_crack/app_routes.dart' as routes;

class WordListItem extends StatelessWidget {

  final String wordListName;
  final void Function() onEditPressed; 
  final void Function() onDeletePressed;

  const WordListItem({
    super.key,
    required this.wordListName,
    required this.onEditPressed,
    required this.onDeletePressed
  });

  String _truncateFileName(String fileName, [int maxLength = 20]) {
    return fileName.length > maxLength
      ? "${fileName.substring(0, maxLength)}..."
      : fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_truncateFileName(wordListName)),
          Wrap(
            children: [
              IconButton(
                onPressed: onEditPressed,
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: onDeletePressed,
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class WordListsScreen extends HookConsumerWidget {
  const WordListsScreen({super.key});


  void _handleState(BuildContext context, WordListsScreenState screenState) {
    switch(screenState.state){
      case WordListConcreteState.wordListCreated:
        showSnackBar(context, "New word list created!");
        break;
      case WordListConcreteState.unableToDeleteWordList:
        showErrorSnackBar(context, "Unable to remove this wordlist.");
        break;
      case WordListConcreteState.wordListDeleted:
        showSnackBar(context, "Word list removed.");
        break;
      case WordListConcreteState.unableToCreateWordList:
        showErrorSnackBar(context, "An error occurred, unable to create a new word list");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final notifier = ref.read(wordListsScreenNotifierProvider.notifier);
    final wordListsScreenState = ref.watch(wordListsScreenNotifierProvider);

    ref.listen<WordListsScreenState>(
      wordListsScreenNotifierProvider,
      (_, state) => _handleState(context, state)
    );

    return Scaffold(
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
            wordListsScreenState.state == WordListConcreteState.loading 
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : Expanded(
                child: ListView.builder(
                  itemCount: wordListsScreenState.wordLists.length,
                  itemBuilder: (context, index) => WordListItem(
                    wordListName: wordListsScreenState.wordLists[index], 
                    onEditPressed: () => navigateTo(
                      context, 
                      routes.editWordList,
                      arguments: wordListsScreenState.wordLists[index],
                    ).whenComplete(
                      () => notifier.loadWordListsName()
                    ),
                    onDeletePressed: () {
                      final name = wordListsScreenState.wordLists[index];
                      notifier.deleteWordList(name);
                    }
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.createWordList(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
