// PACKAGES
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//CUSTOM PAGES & WIDGETS
import './pages/default_view.dart';
import './pages/settings.dart';
import './pages/auth.dart';

//CUSTOM MODELS
import './scoped_models/main_model.dart';
import './models/event.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  //instantiates a new model of type MainModel (one i created which combines a ton of models)
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  // Runs some code when the program starts
  @override
  initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //the whole app is wrapped in the combined scoped model. Scoped model manages state of the app and helps update things
    return ScopedModel<MainModel>(
      //the model the entire app will use
      model: _model,
      //entire material app
      child: MaterialApp(
        title: 'Reach',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.blueAccent,
        ),
        routes: {
          // '/' is the first page the app opens. If authenicated already go to the default page (homescreen and stuff) otherwise => authentication page
          '/': (BuildContext context) =>
              (_isAuthenticated) ? DefaultPage(_model) : AuthPage(),
          // '/settings' is the settings page. If we are on the settings page and get logged out, then we will be redirected to authentication page again
          '/settings': (BuildContext context) =>
              (_isAuthenticated) ? SettingsPage() : AuthPage(),
        },

        //this is for when the app wants to make a new page using named routes. This will be like go to event 1's info page and passed as '/event1'. This is dynamic
        onGenerateRoute: (RouteSettings settings) {
          //if not authenticated, go to the authentication page (login screen)
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }

          // new list of the elements the user will pass in. Split the elements by the '/'.
          final List<String> pathElements = settings.name.split('/');
          //if the first element is not nothin', then return nothin'
          if (pathElements[0] != '') {
            return null;
          }
          // if (pathElements[1] == 'event') {
          //   final String eventID = pathElements[2];
          //   final Event event = _model.allEvents.firstWhere((Event event) {
          //     return event.id == eventID;
          //   });
          //   return MaterialPageRoute<bool>(
          //     builder: (BuildContext context) =>
          //         _isAuthenticated ? EventPage(event) : AuthPage(),
          //   );
          // }

          // if none of these are met, return null
          return null;
        },

        // if the named route is passed in and the app cannot find it (it doesn't exist), then this will be the default. This is basically a catch all
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            // and if the user is not authenticated, then send them to the login screen (like above)
            builder: (BuildContext context) =>
                _isAuthenticated ? DefaultPage(_model) : AuthPage(),
          );
        },
      ),
    );
  }
}
