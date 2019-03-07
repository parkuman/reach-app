// PACKAGES
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//CUSTOM PAGES & WIDGETS
import './pages/default_view.dart';
import './pages/profile.dart';
import './pages/events.dart';
import './pages/settings.dart';
import './pages/auth.dart';

//CUSTOM MODELS
import './scoped_models/main_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    

    //instantiates a new model of type MainModel (one i created which combines a ton of models)
    final MainModel model = MainModel();

    //the whole app is wrapped in the combined scoped model. Scoped model manages state of the app and helps update things
    return ScopedModel<MainModel>(
      //the model the entire app will use
      model: model,
      //entire material app
      child: MaterialApp(
        title: 'Reach',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.blueAccent,
        ),
        routes: {
          // default page, this is going to be the first one to open in the app
          '/': (BuildContext context) => AuthPage(),
          '/default': (BuildContext context) => DefaultPage(model),
          '/profile': (BuildContext context) => ProfilePage(),
          '/events': (BuildContext context) => EventsPage(),
          '/settings': (BuildContext context) => SettingsPage(),
        },
      ),
    );
  }
}
