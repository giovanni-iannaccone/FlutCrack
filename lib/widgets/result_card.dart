import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {

  final String title;
  final String? subtitle;
  final bool error;

  final void Function()? onCopyPressed;

  const ResultCard({
    super.key,
    required this.title,
    this.error = false,
    this.subtitle,
    this.onCopyPressed
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              subtitle: Text(subtitle ?? ""),
              leading: Icon(
                color: error ? Colors.red : Colors.greenAccent,
                error 
                  ? Icons.highlight_off 
                  : Icons.check_circle
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: !error ? onCopyPressed : null,
                  child: const Text("Copy")
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
