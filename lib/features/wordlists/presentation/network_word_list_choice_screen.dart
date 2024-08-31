import 'package:flut_crack/core/utils/snackbar_utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:flut_crack/core/utils/navigation_utils.dart';
import 'package:flut_crack/features/wordlists/presentation/state/download_word_list_state_notifier.dart';

class NetworkWordListChoiceScreen extends HookConsumerWidget {
  const NetworkWordListChoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickedFilePath = extractArguments<ValueNotifier<String?>>(context);  
    final wordListLinkController = useTextEditingController();

    final notifier = ref.read(downloadWordListScreenNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Use an online wordlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: wordListLinkController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.download),
                hintText: "Link of the wordlist",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (wordListLinkController.text.isNotEmpty) {
                  notifier.downloadWordList(wordListLinkController.text);
                  pickedFilePath.value = wordListLinkController.text.split('/').last;
                  Navigator.of(context).pop();
                } else {
                  showErrorSnackBar(context, "Use a valid url");
                }
              },
              label: const Text("Send request"),
              icon: const Icon(Icons.arrow_right_alt)
            ),
          ]
        )
      )
    );
  }
}