import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';

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
            title:
                Text('Logins', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return ListTile(
                title: Text('Logout', style: TextStyle(color: Colors.blue)),
                onTap: () {
                  model.logout();
                  Navigator.pop(context);
                  // no longer needed due to state management with RX darts publish listen thingysy
                  // Navigator.pushReplacementNamed(context, '/');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
