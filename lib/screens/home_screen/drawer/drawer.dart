import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onSettingsPressed;

  const CustomDrawer({
    required this.onHomePressed,
    required this.onSettingsPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home',
              style: TextStyle(color: Colors.white),),
            onTap: onHomePressed,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings',
              style: TextStyle(color: Colors.white),),
            onTap: onSettingsPressed,
          ),
        ],
      ),
    );
  }
}

