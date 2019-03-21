import 'package:flutter/material.dart';

import './user.dart';


// EVENT CLASS: this stores all the aspects of what an event has
class Event {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String location;
  final String hostEmail;
  final String hostID;
  final List<User> attendees;

  Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.latitude,
    @required this.longitude,
    @required this.location,
    @required this.hostEmail,
    @required this.hostID,
    this.attendees,
  });
}
