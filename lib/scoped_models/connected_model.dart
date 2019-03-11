import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/event.dart';
import '../models/user.dart';
import '../models/auth.dart';

mixin ConnectedModel on Model {
  List<Event> _events = [];
  User _authenticatedUser;
  bool _isLoading = false;
  String _selectedEventID;
}

mixin EventModel on ConnectedModel {
  // ADD EVENT
  Future<bool> addEvent(
      String title, String description, String location) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> eventData = {
      'title': title,
      'description': description,
      'location': location,
      'hostEmail': _authenticatedUser.email,
      'hostID': _authenticatedUser.id,
    };

    try {
      final http.Response response = await http.post(
          'https://reach-app-1.firebaseio.com/events.json?auth=${_authenticatedUser.token}',
          body: json.encode(eventData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      final Event newEvent = Event(
        id: responseData['name'],
        title: title,
        description: description,
        location: location,
        hostEmail: _authenticatedUser.email,
        hostID: _authenticatedUser.id,
      );
      _events.add(newEvent);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      print('error with add card http request');
      return false;
    }
  }

  // UPDATE EVENT
  Future<bool> updateEvent(
      {String title, String description, String location, String id}) async {
    _isLoading = true;
    notifyListeners();

    // finds the event we want to update using the id the user passed to the updateEvent method
    final Event eventToUpdate = _events.firstWhere((Event event) {
      return event.id == id;
    });

    //the data we want to send to the server with some updated info
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'location': location,
      'hostEmail': eventToUpdate.hostEmail,
      'hostID': eventToUpdate.hostID,
    };

    try {
      await http.put(
          'https://reach-app-1.firebaseio.com/events/${eventToUpdate.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));

      _isLoading = false;

      // the updated event, now with an id
      final Event updatedEvent = Event(
        id: eventToUpdate.id,
        title: title,
        description: description,
        location: location,
        hostEmail: eventToUpdate.hostEmail,
        hostID: eventToUpdate.hostID,
      );

      // find the index in _events where the selected event dwells
      final int eventToUpdateIndex = _events.indexWhere((Event event) {
        return event.id == id;
      });
      // use the found dwelling index to change the selected event to the new updated one
      _events[eventToUpdateIndex] = updatedEvent;

      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      print('error with update card http request');
      return false;
    }
  }

  // DELETE EVENT
  Future<bool> deleteEvent({String id}) async {
    _isLoading = true;

    final int deletedEventIndex = _events.indexWhere((Event event) {
      return event.id == id;
    });
    _events.removeAt(deletedEventIndex);
    notifyListeners();

    try {
      http.delete(
          'https://reach-app-1.firebaseio.com/events/$id.json?auth=${_authenticatedUser.token}');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      print('error with delete card http request');
      return false;
    }
  }

  //FETCH EVENTS
  Future<bool> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          'https://reach-app-1.firebaseio.com/events.json?auth=${_authenticatedUser.token}');
      _isLoading = false;
      notifyListeners();
      final List<Event> fetchedEventList = [];
      final Map<String, dynamic> eventListData = json.decode(response.body);

      if (eventListData == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // go through each fetched event from the gathered data, this will create a list of all the events on the server
      eventListData.forEach((String eventID, dynamic eventData) {
        //create a new event for each and assign it values from the fetched json data
        final Event event = Event(
          id: eventID,
          title: eventData['title'],
          description: eventData['description'],
          location: eventData['location'],
          hostEmail: eventData['hostEmail'],
          hostID: eventData['hostID'],
        );
        //add it to the fetched card list
        fetchedEventList.add(event);
      });
      
      // replace existing events with the newly fetched events from the server
      _events = fetchedEventList;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      print('error with fetch events http request');
      return false;
    }
  }
}

// Scoped model for the user sign in
mixin UserModel on ConnectedModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  User get authenticatedUser {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDMI-orHMYBMmm1oKbbvMRRyZn_NlM8ie8',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDMI-orHMYBMmm1oKbbvMRRyZn_NlM8ie8',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool success = false;
    String message;
    if (responseData.containsKey('idToken')) {
      success = true;
      message = 'Authentication Succeded!';
      //tell the program a new user is signed in
      _authenticatedUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken'],
      );

      setAuthTimeout(int.parse(responseData['expiresIn']));

      //update the state of the user subject to true (therefore authenticated)
      _userSubject.add(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Invalid password';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else {
      message = 'Authentication Failed';
    }

    _isLoading = false;
    notifyListeners();

    return {'success': success, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');

    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);

      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }

      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);

      //update the state of the user subject to true (therefore authenticated)
      _userSubject.add(true);

      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    //clear authenticated user
    _authenticatedUser = null;
    //update the state of the user subject to false (therefore unauthenticated)
    _userSubject.add(false);
    _authTimer.cancel();

    //remove all the locally stores user info
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');

    notifyListeners();
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedModel {
  bool get isLoading {
    return _isLoading;
  }
}
