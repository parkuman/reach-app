import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';
import '../models/event.dart';

class EventsList extends StatelessWidget {
  final MainModel model;
  EventsList(this.model);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildEventsList(model.displayedEvents);
      },
    );
  }

  Widget _buildEventsList(List<Event> events) {
    Widget eventItem;
    if (events.length > 0) {
      eventItem = ListView.builder(
        itemBuilder: ((BuildContext context, int index) {
          return eventCard(model.displayedEvents[index], index);
        }),
        itemCount: events.length,
      );
    } else {
      eventItem = Center(
        child: Text('no events found'),
      );
    }

    return eventItem;
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
            onTap: () {
              print('card pressed');
              // card pressed
            },
            onLongPress: () {
              print('card long pressed');
            },
            child: Card(
              elevation: 3.0,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    //TEXT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Event',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text('${event.hostEmail}'),
                        Text('${event.id}'),
                      ],
                    ),
                    //SPACE BETWEEN PIC AND TEXT
                    Expanded(
                      child: SizedBox(),
                    ),
                    //PICTURE BOX
                    Container(
                      width: 100.0,
                      height: 100.0,
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
