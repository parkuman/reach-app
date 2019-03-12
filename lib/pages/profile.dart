import 'package:flutter/material.dart';

import '../scoped_models/main_model.dart';

class ProfilePage extends StatelessWidget {
  final Function onSettingsButton;
  final MainModel model;
  ProfilePage({this.onSettingsButton, this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => onSettingsButton(), // Navigator.pushNamed(context, '/settings');
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50.0, bottom: 15.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/parker.jpg'),
                  radius: 75.0,
                ),
              ),
              Text(
                '${model.authenticatedUser.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
              Text(
                '${model.authenticatedUser.email}',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                '${model.authenticatedUser.id}',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
