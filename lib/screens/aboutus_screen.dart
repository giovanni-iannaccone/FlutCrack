import 'package:flutter/material.dart';
import 'package:flut_crack/widgets/nav.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("About FlutCrack"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                Icons.thumb_up, 
                color: Theme.of(context).colorScheme.primary
              ),
              title: const Text("FlutCrack 1.1"),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
              title: const Text("Creator: Giovanni Iannaccone"),
            ),
            ListTile(
              leading: Icon(Icons.balance, color: Theme.of(context).colorScheme.primary),
              title: const Text("License: GPL-3.0"),
            ),
            ListTile(
              leading: Icon(Icons.code, color: Theme.of(context).colorScheme.primary),
              title: const Text("Source code:"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "https://github.com/giovanni-iannaccone/FlutCrack",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Spacer(),
            const Text("Thanks to all the Flutter development team. Happy hacking"),
          ],
        ),
      ),
    );
  }
}
