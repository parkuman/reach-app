import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      // body: Center(child: Text('Settings')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Setting 1'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Setting 2'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Setting 3'),
            onTap: () {},
          ),
          ListTile(),
          ListTile(
            title: Text('Logins', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: Text('Logout', style: TextStyle(color: Colors.blue)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          
        ],
      ),
    );
  }
}
