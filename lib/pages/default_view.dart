import 'package:flutter/material.dart';

import '../widgets/bottom_bar_3.dart';
import './home.dart';
import './profile.dart';
import './events.dart';


class DefaultPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DefaultPageState();
  }
}

class _DefaultPageState extends State<DefaultPage> {
  int _selectedPage = 1;
  final _pageOptions = [
    EventsPage(),
    HomePage(),
    ProfilePage(),
  ];


  void _updateState (int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SimpleBottomAppBar(_updateState),
        body: _pageOptions[_selectedPage],
        );
  }
}


