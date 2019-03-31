import 'package:flutter/material.dart';


// EVENT CLASS: this stores all the aspects of what an event has
class Event {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String location;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int attendeeLimit;
  final List<dynamic> attendees;
  final String image;
  final String hostEmail;
  final String hostID;

  Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.latitude,
    @required this.longitude,
    @required this.location,
    @required this.startDateTime,
    @required this.endDateTime,
    @required this.attendeeLimit,
    @required this.attendees,
    @required this.image,
    @required this.hostEmail,
    @required this.hostID,
  });
}
