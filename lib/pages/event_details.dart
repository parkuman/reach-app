import 'package:flutter/material.dart';
import '../scoped_models/main_model.dart';

class EventDetailsPage extends StatelessWidget {
  final MainModel model;
  final int eventIndex;
  EventDetailsPage(this.model, {this.eventIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${eventIndex+1}'),),
      body: Center(
        child: Text('Event Id: ${model.allEvents[eventIndex].id}'),
      ),
    );
  }
}
