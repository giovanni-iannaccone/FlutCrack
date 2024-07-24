import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildCard(String word, int? triedWords) {
  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            title: Text(word),
            subtitle: triedWords != null
              ? Text("Match found after $triedWords words")
              : const Text(""),

            leading: const Icon(
              color: Colors.greenAccent,
              Icons.check_circle
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text("Copy"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: word));
                }
              )
            ],
          )
        ],
      ),
    )
  );
}
