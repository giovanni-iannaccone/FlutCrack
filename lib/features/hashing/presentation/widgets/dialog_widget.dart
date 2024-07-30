import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  
  final void Function() onFilePick;
  final void Function() onWordListPick;
  
  const DialogWidget({
    super.key,
    required this.onFilePick,
    required this.onWordListPick  
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                onFilePick();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Pick a file'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                onWordListPick();
              },
              icon: const Icon(Icons.file_open),
              label: const Text('Use a in-app created wordlist'),
            ),
          ],
        ),
      )
    );
  }
}