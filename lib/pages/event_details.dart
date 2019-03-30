import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';

class EventDetailsPage extends StatefulWidget {
  final MainModel model;
  final int eventIndex;
  EventDetailsPage(this.model, {this.eventIndex});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventIndex + 1}'),
      ),
      body: Center(child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return RaisedButton(
            color: Theme.of(context).accentColor,
            // if loading display a progrss indicator
            child: model.isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                // if not display text, display reach if the user isnt going yet, display UNREACH if the user is
                : Text(model.allEvents[widget.eventIndex].attendees
                        .contains(model.authenticatedUser.id)
                    ? 'UN-REACH'
                    : 'REACH'),
            onPressed: () {
              widget.model.reachEvent(model.displayedEvents[widget.eventIndex]);
            },
          );
        },
      )),
    );
  }
}
