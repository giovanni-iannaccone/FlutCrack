import 'package:flutter/material.dart';
import 'package:flut_crack/widgets/nav.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("FlutCrack"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        margin: const EdgeInsets.all(30.0),

        child: const Column(children: [
          Row(
            children: [
              Icon(Icons.thumb_up),
              Text("\tFlutCrack 1.0"),
            ],
          ),
          Row(
            children: [
              Icon(Icons.person),
              Text("\tCreator: Giovanni Iannaccone"),
            ],
          ),
          Row(
            children: [
              Icon(Icons.balance),
              Text("\tLicense: GPL-3.0"),
            ],
          ),
          Row(
            children: [
              Icon(Icons.code),
              Text("\tSource code:"),
            ],
          ),
          Text("https://github.com/giovanni-iannaccone/FlutCrack")
        ]),
      ),
    );
  }
}
