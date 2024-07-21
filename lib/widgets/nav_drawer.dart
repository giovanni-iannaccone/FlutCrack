import 'package:flut_crack/app_routes.dart' as routes;
import 'package:flut_crack/utils/navigation_utils.dart' show navigateTo;

import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 25
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => navigateTo(context, routes.home),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_added),
            title: const Text('Wordlists'),
            onTap: () => navigateTo(context, routes.dictionary),
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text('About Us'),
            onTap: () => navigateTo(context, routes.credits),
          ),
        ],
      ),
    );
  }
}
