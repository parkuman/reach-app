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
      String title, String description, String location, String eventID) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'location': location,
      'hostEmail': _authenticatedUser.email,
      'hostID': _authenticatedUser.id,
    };

    //UNFINISHED
    try {
      final http.Response response = await http.put(
          'https://reach-app-1.firebaseio.com/events/${eventID}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      print('error with add card http request');
      return false;
    }
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
