import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';
import '../models/event.dart';

class EventDetailsPage extends StatefulWidget {
  



class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( 'HI'
      ),),
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
}