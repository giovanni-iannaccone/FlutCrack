import 'package:flut_crack/app_routes.dart' as routes;

import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  void navigateTo(String targetRoute, BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        targetRoute,
        (Route<dynamic> route) => route.settings.name == targetRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Welcome',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => {
              navigateTo(routes.home, context),
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_added),
            title: const Text('Wordlists'),
            onTap: () => {
              navigateTo(routes.dictionary, context),
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text('About Us'),
            onTap: () => {
              navigateTo(routes.credits, context),
            },
          ),
        ],
      ),
    );
  }
}
