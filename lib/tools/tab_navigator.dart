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
import '../pages/event_details.dart';
import '../models/event.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String settings = '/settings';
  static const String createEvent = '/createEvent';
  static const String eventDetails = '/eventDetails';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem, this.model});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final MainModel model;

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

  void _eventDetails(BuildContext context, {int index}) {
    var routeBuilders = _routeBuilders(context, index: index);
    // Navigator.pushNamed(
    //   context,
    //   TabNavigatorRoutes.eventDetails + '/event/' + model.allEvents[index].id,
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.eventDetails](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, {int index}) {
    return {
      TabNavigatorRoutes.root: (context) {
        if (tabItem == TabItem.events) {
          return EventsPage(
            onCreateEventButton: () => _createEvent(context),
            onDetailsButton: (int index) {
              _eventDetails(context, index: index);
            },
            model: model,
          );
        } else if (tabItem == TabItem.home) {
          return HomePage(
            onDetailsButton: (int index) {
              // so that the settings the events has 
              model.showUserAttendingEvents = false;
              model.showUserHostingEvents = false;
              _eventDetails(context, index: index);
            },
            model: model,
          );
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
      //for the eventDetails page on home & event screen
      TabNavigatorRoutes.eventDetails: (context) =>
          EventDetailsPage(model, eventIndex: index),
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
