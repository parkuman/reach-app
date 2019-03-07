import 'package:flutter/material.dart';


// USER CLASS: stores all the aspects of what a user looks like on the reach app
class User {
  final String id;
  final String email;
  final String password;

  User({
    @required this.id,
    @required this.email,
    @required this.password,
  });
}
