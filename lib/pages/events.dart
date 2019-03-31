import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../scoped_models/main_model.dart';
import '../widgets/advertisement.dart';
import '../models/event.dart';
import '../widgets/attendee_bar.dart';

class EventsPage extends StatefulWidget {
  final MainModel model;
  final Function onCreateEventButton;
  final Function onDetailsButton;
  EventsPage({this.model, this.onCreateEventButton, this.onDetailsButton});

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
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            widget.onCreateEventButton();
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Events', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: <Widget>[
              Container(
                  padding: EdgeInsets.all(15.0), child: Text('All Events')),
              Container(padding: EdgeInsets.all(15.0), child: Text('Going')),
              Container(padding: EdgeInsets.all(15.0), child: Text('Hosting')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildEventsList(0),
            _buildEventsList(1),
            _buildEventsList(2),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(int tab) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (tab == 0) {
          model.showUserAttendingEvents = false;
          model.showUserHostingEvents = false;
        } else if (tab == 1) {
          model.showUserHostingEvents = false;
          model.showUserAttendingEvents = true;
        } else if (tab == 2) {
          model.showUserAttendingEvents = false;
          model.showUserHostingEvents = true;
        }
        Widget content = Center(child: Text('No Content Found'));
        if (!model.isLoading) {
          if (model.displayedEvents.length > 0) {
            content = ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                // EVERY X EVENTS DISPLAY AN AD
                return (index % 4 == 0 && index != 0)
                    ? Advertisement(height: 250.0, color: Colors.yellow[200],)
                    : Container();
              },
              itemBuilder: (BuildContext context, int index) {
                return eventCard(model.displayedEvents[index], index);
              },
              itemCount: model.displayedEvents.length,
            );
          } else {
            content = Center(
              child: Text('no events found'),
            );
          }
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

  Widget eventCard(Event event, int index) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Dismissible(
          key: Key(model.displayedEvents[index].id),
          onDismissed: (DismissDirection direction) {
            model.deleteEvent(
              id: event.id,
            );
          },
          child: GestureDetector(
            onTap: () => widget.onDetailsButton(index),
            onLongPress: () {
              print('card long pressed');
            },
            child: Card(
              elevation: 2.0,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    //TEXT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${event.title}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(model.displayedEvents[index].location
                            .split(',')[0]),
                        Text(
                            '${DateFormat.EEEE().format(model.displayedEvents[index].startDateTime)}, ${DateFormat.jm().format(model.displayedEvents[index].startDateTime)}'),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text('Host: ${event.hostEmail.split('@')[0]}'),
                      ],
                    ),
                    //SPACE BETWEEN PIC AND TEXT
                    Expanded(
                      child: event.attendeeLimit == -1
                          ? SizedBox()
                          : Column(children: <Widget>[
                              AttendeeAmountBar(index),
                              Text(
                                '${event.attendees.length - 1}/${event.attendeeLimit} going',
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ]),
                    ),
                    //PICTURE BOX
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/event.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
