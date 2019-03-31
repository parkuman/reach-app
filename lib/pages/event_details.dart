import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';

class EventDetailsPage extends StatefulWidget {
  final MainModel model;
  final int eventIndex;
  final bool isHomePage;
  EventDetailsPage(this.model, {this.eventIndex, this.isHomePage});

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
      body: Center(
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return model.isLoading
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Theme.of(context).accentColor,
                    // if loading display a progrss indicator
                    child: Text(model.allEvents[widget.eventIndex].attendees
                            .contains(model.authenticatedUser.email)
                        ? 'UN-REACH'
                        : 'REACH'),
                    onPressed: () {
                      widget.model
                          .reachEvent(model.displayedEvents[widget.eventIndex]);
                    },
                  );
          },
        ),
      ),
    );
  }
}
