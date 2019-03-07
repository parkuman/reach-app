import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
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
                'User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
              Text(
                'email',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(
                'age',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
