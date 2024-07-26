import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  
  final void Function() onFilePick;
  final void Function() onWordListPick;
  final BuildContext? context;
  
  const DialogWidget({
    super.key, 
    this.context,
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
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                onFilePick();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Pick a file'),
            ),

            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                onWordListPick();
                Navigator.pop(context);
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