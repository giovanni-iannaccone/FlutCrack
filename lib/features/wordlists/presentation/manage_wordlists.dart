import 'package:flut_crack/core/word_list_manager.dart';
import 'package:flut_crack/features/hashing/presentation/state/search_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WordListsScreen extends HookConsumerWidget {
  const WordListsScreen({super.key});

  Future<List<String>> _loadWordLists(WordListManager wordListManager) async {
    return await wordListManager.getDictionariesNames();
  }

  Future<void> _deleteWordList(String wordList, WordListManager wordListManager, ValueNotifier<List<String>> wordLists) async {
    await wordListManager.deleteWordList(wordList);
    wordLists.value = await _loadWordLists(wordListManager);
  }

  String _truncateFileName(String fileName) {
    return fileName.length > 25 ? '${fileName.substring(0, 25)}...' : fileName;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExtended = useState(true);
    final scrollController = useScrollController();
    
    final searchText = ref.watch(searchBarProvider);

    final wordListManager = WordListManager();
    final wordLists = useState<List<String>>([]);

    useEffect(() {
      void listener() {
        if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (isExtended.value) isExtended.value = false;
        } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (!isExtended.value) isExtended.value = true;
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    useEffect(() {
      _loadWordLists(wordListManager).then((lists) => wordLists.value = lists);
      return null;
    }, []);

    final filteredWordLists = useMemoized(() {
      if (searchText.isEmpty) {
        return wordLists.value;
      } else {
        return wordLists.value.where((wordList) {
          return wordList.toLowerCase().contains(searchText.toLowerCase());
        }).toList();
      }
    }, [searchText, wordLists.value]);

    return Scaffold(
      body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      ref.read(searchBarProvider.notifier).update((state) => state = value);
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: filteredWordLists.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_truncateFileName(filteredWordLists[index])),
                            Wrap(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context).pushNamed('/edit', arguments: filteredWordLists[index]),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _deleteWordList(filteredWordLists[index], wordListManager, wordLists);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String date = DateTime.now().toString();
          await wordListManager.createNewWordlist("wordList-$date.txt");
          wordLists.value = await _loadWordLists(wordListManager);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
