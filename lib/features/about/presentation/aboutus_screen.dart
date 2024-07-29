import 'package:flut_crack/core/utils/theme_utils.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final colorScheme = colorSchemeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                Icons.thumb_up, 
                color: colorScheme.primary
              ),
              title: const Text("FlutCrack 2.0"),
            ),
            ListTile(
              leading: Icon(Icons.balance, color: colorScheme.primary),
              title: const Text("License: GPL-3.0"),
            ),
            ListTile(
              leading: Icon(Icons.code, color: colorScheme.primary),
              title: const Text("Source code:"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "https://github.com/giovanni-iannaccone/FlutCrack",
                style: TextStyle(
                  color: colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Spacer(),
            const Text("A big thank you to the Flutter development team and everyone who contributed to the app. Happy Hacking !"),
          ],
        ),
      ),
    );
  }
}
