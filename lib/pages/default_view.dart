import 'package:flutter/material.dart';

import '../widgets/bottom_bar_3.dart';

import '../scoped_models/main_model.dart';
import '../models/tabItem.dart';
import '../tools/tab_navigator.dart';

class DefaultPage extends StatefulWidget {
  final MainModel model;
  DefaultPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _DefaultPageState();
  }
}

class _DefaultPageState extends State<DefaultPage> {
  TabItem currentTab = TabItem.home;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.events: GlobalKey<NavigatorState>(),
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  void _selectTab(int index) {
    TabItem tabItem;
    switch (index) {
      case 0:
        tabItem = TabItem.events;
        break;
      case 1:
        tabItem = TabItem.home;
        break;
      case 2:
        tabItem = TabItem.profile;
        break;
    }
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        bottomNavigationBar: SimpleBottomAppBar(
          onSelectTab: _selectTab,
        ),
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.events),
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.profile),
        ]),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
        model: widget.model,
      ),
    );
  }
}
