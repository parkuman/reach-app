import 'package:flutter/material.dart';
// import 'package:nested_navigation_demo_flutter/bottom_navigation.dart';
// import 'package:nested_navigation_demo_flutter/color_detail_page.dart';
// import 'package:nested_navigation_demo_flutter/colors_list_page.dart';

import '../scoped_models/main_model.dart';
import '../models/tabItem.dart';
import '../pages/events.dart';
import '../pages/home.dart';
import '../pages/profile.dart';
import '../pages/settings.dart';
import '../pages/event_create.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String settings = '/settings';
  static const String createEvent = '/createEvent';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.model});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final MainModel model;

  // FOR PUSHING CERTAIN THINGSS
  void _settings(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.settings](context),
      ),
    );
  }

  // FOR PUSHING CERTAIN THINGSS
  void _createEvent(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.createEvent](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) {
        if (tabItem == TabItem.events) {
          return EventsPage(
            onCreateEventButton: () => _createEvent(context),
            model: model,
          );
        } else if (tabItem == TabItem.home) {
          return HomePage(model);
        } else if (tabItem == TabItem.profile) {
          return ProfilePage(
            onSettingsButton: () => _settings(context),
            model: model,
          );
        }
      },

      //for the settings page on the profile screen
      TabNavigatorRoutes.settings: (context) => SettingsPage(model),
      //for the create event page on the events screen
      TabNavigatorRoutes.createEvent: (context) => EventCreatePage(model),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        });
  }
}
