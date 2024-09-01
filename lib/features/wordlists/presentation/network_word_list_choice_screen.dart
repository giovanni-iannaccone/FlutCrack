import 'package:flut_crack/core/utils/snackbar_utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:flut_crack/core/utils/navigation_utils.dart';
import 'package:flut_crack/features/wordlists/presentation/state/download_word_list_state_notifier.dart';

class NetworkWordListChoiceScreen extends HookConsumerWidget {
  const NetworkWordListChoiceScreen({super.key});

   void _handleState(BuildContext context, NetworkScreenState screenState) {
    switch(screenState.state){
      case NetworkConcreteState.downloadFailed:
        showErrorSnackBar(context, "Use a valid URL or check you connection");
        break;
      case NetworkConcreteState.downloadSuccess:
        showSnackBar(context, "Wordlist downloaded");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pickedFilePath = extractArguments<ValueNotifier<String?>>(context);  
    final wordListLinkController = useTextEditingController();

    final notifier = ref.read(downloadWordListScreenNotifierProvider.notifier);
    final state = ref.watch(downloadWordListScreenNotifierProvider);

    ref.listen<NetworkScreenState>(
      downloadWordListScreenNotifierProvider,
      (_, state) { 
        _handleState(context, state);
        if (state.state == NetworkConcreteState.downloadSuccess) {
          pickedFilePath.value = wordListLinkController.text.split('/').last;
          Navigator.of(context).pop();
        }
      }
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Download an online wordlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: wordListLinkController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.link),
                hintText: "Link of the wordlist",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                notifier.downloadWordList(wordListLinkController.text);
              },
              label: const Text("Download"),
              icon: const Icon(Icons.download)
            ),

            if (state.state == NetworkConcreteState.downloading)
              const CircularProgressIndicator(),
          ]
        )
      )
    );
  }
}