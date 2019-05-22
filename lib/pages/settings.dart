import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';

class SettingsPage extends StatelessWidget {
  final MainModel model;
  SettingsPage(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text('My Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${model.authenticatedUser.email.split('@')[0]}'),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${model.authenticatedUser.email}'),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Birthday',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('03/02/2000'),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('613-784-0122'),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Passwords',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Privacy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Logins',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {},
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
