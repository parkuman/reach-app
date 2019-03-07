import 'package:scoped_model/scoped_model.dart';

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

    try {/*HTTP CODE*/} catch (error) {/*CATCH THE ERROR*/}
  }

  // UPDATE EVENT
  Future<bool> updateEvent(
      String title, String description, String location) async {
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'location': location,
      'hostEmail': _authenticatedUser.email,
      'hostID': _authenticatedUser.id,
    };

    try {/*HTTP CODE*/} catch (error) {/*CATCH THE ERROR*/}
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

mixin UserModel on ConnectedModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: '0', email: email, password: password);
  }
}
