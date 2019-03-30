import 'package:flutter/material.dart';
import '../scoped_models/main_model.dart';
import '../models/event.dart';

class EventDetailsPage extends StatelessWidget {
  final MainModel model;
 
  final int eventIndex;

  EventDetailsPage(this.model, {this.eventIndex});// add name, description, hosting email, location, people invited   '${eventIndex+1}'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${eventIndex+1}'),),
      body: 
       // child: Text('Event Id: ${model.allEvents[eventIndex].id}'), 
        Container(
                      width: 450.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/event.jpg'),
                        ),
                      ),
                    )
      );
    
  }
}
