import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/events_list.dart';
import '../scoped_models/main_model.dart';

class EventsPage extends StatefulWidget {
  final MainModel model;
  final Function onCreateEventButton;
  EventsPage({this.model, this.onCreateEventButton});

  @override
  State<StatefulWidget> createState() {
    return _EventsPageState();
  }
}

class _EventsPageState extends State<EventsPage> {

  void initState() {
    widget.model.fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            widget.onCreateEventButton();
            // setState(() {
            //   widget.model.addEvent(widget.model.authenticatedUser.email, widget.model.authenticatedUser.id, 'location');
            // });
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Events', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: <Widget>[
              Container(padding: EdgeInsets.all(15.0), child: Text('Going')),
              Container(padding: EdgeInsets.all(15.0), child: Text('Hosting')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildEventsList(),
            Center(child: Text('Hosting')),
          ],
        ),
      ),
    );
  }

Widget _buildEventsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Content Found'));
        if (model.displayedEvents.length > 0 && !model.isLoading) {
          content = EventsList(model);
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          child: content,
          onRefresh: model.fetchEvents,
        );
      },
    );
  }


  
}
