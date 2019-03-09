import 'package:flutter/material.dart';

import '../widgets/bottom_bar_3.dart';
import './home.dart';
import './profile.dart';
import './events.dart';

import '../scoped_models/main_model.dart';


class DefaultPage extends StatefulWidget {
  final MainModel model;
  DefaultPage(this.model);
  
  @override
  State<StatefulWidget> createState() {
    return _DefaultPageState();
  }
}

class _DefaultPageState extends State<DefaultPage> {
   
   //to make new EVENTS BRO AS A TEST AHAHAHAHAHAHAH
   void initState(){
      widget.model.addEvent('title', 'description', 'location');
      super.initState();
    }


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


