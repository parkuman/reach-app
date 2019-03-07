import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/event.dart';
import '../models/user.dart';

mixin ConnectedModel on Model {
  List<Event> _events = [];
  User _authenticatedUser;
}

mixin EventModel on ConnectedModel {
  // ADD EVENT
  Future<bool> addEvent(
      String title, String description, String location) async {
    final Map<String, dynamic> eventData = {
      'title': title,
      'description': description,
      'location': location,
      'hostEmail': _authenticatedUser.email,
      'hostID': _authenticatedUser.id,
    };

    try {
      final http.Response response = await http.post(
          'https://reach-app-1.firebaseio.com/events.json',
          body: json.encode(eventData));
      
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Event newEvent = Event(
        id: responseData['name'],
        title: title,
        description: description,
        hostEmail: _authenticatedUser.email,
        hostID: _authenticatedUser.id,
      );
      _events.add(newEvent);
      return true;

    } catch (error) {
      print('error with add card http request');
      return false;
    }
  }

  // UPDATE EVENT
  Future<bool> updateEvent(
      String title, String description, String location, String eventID) async {
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'location': location,
      'hostEmail': _authenticatedUser.email,
      'hostID': _authenticatedUser.id,
    };

    //UNFINISHED
    try {
      final http.Response response = await http.put('https://reach-app-1.firebaseio.com/events/${eventID}.json', body: json.encode(updateData));
    } catch (error) {/*CATCH THE ERROR*/}
  }

  // DELETE EVENT
  Future<bool> deleteEvent() async {
    //code that deletes the shit
    try {/*HTTP CODE*/} catch (error) {/*CATCH THE ERROR*/}
  }

  //FETCH EVENTS
  Future<Null> fetchEvents() {
    try {/*HTTP CODE*/} catch (error) {/*CATCH THE ERROR*/}
  }
}


// Scoped model for the user sign in 
mixin UserModel on ConnectedModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: '0', email: email, password: password);
  }
}
