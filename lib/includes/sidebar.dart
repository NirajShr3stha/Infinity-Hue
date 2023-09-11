import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Sidebar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Purchase Premium'),
            onTap: () {
              // Handle 'Purchase Premium' selection
              Navigator.pop(context);
              // Add your logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('App Theme'),
            onTap: () {
              // Handle 'App Theme' selection
              Navigator.pop(context);
              // Add your logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Handle 'Language' selection
              Navigator.pop(context);
              // Add your logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Image Settings'),
            onTap: () {
              // Handle 'Image Settings' selection
              Navigator.pop(context);
              // Add your logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              // Handle 'Help' selection
              Navigator.pop(context);
              // Add your logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.gavel),
            title: Text('Legal'),
            onTap: () {
              // Handle 'Legal' selection
              Navigator.pop(context);
              // Add your logic here
            },
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text('Web App'),
            onTap: () {
              // Handle 'Web App' selection
              Navigator.pop(context);
              // Add your logic here
            },
          ),
        ],
      ),
    );
  }
}