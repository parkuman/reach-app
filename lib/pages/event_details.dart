import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../scoped_models/main_model.dart';
import '../pages/home.dart';

class EventDetailsPage extends StatefulWidget {
  final MainModel model;
  final int eventIndex;
EventDetailsPage(this.model,{this.eventIndex});

@override
  State<StatefulWidget> createState() {
    return _EventDetailsPageState();
  }
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model.displayedEvents[widget.eventIndex].title}'),
      ),
      body:ListView( 
        children: <Widget>[
      Container(
                      width: 250.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('${widget.model.displayedEvents[widget.eventIndex].image}'),
                        ),
                      ),
      ),
      
        ListTile(
           
             title: Text('Description', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text('${widget.model.displayedEvents[widget.eventIndex].description}'),
            onTap: () {},
          ),
          ListTile(
           
             title: Text('Location', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle:  Text('${widget.model.displayedEvents[widget.eventIndex].location}'),

                trailing: 
           IconButton(            
            icon: Icon(Icons.location_on),
            onPressed: () {},
            ),
               
            onTap: () {}
            ,
          ),ListTile(
           
             title: Text('Attendees', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle:  Text('${widget.model.displayedEvents[widget.eventIndex].attendees}'),
            onTap: () {},
          ),ListTile(
           
             title: Text('Max Attendees', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text('${widget.model.displayedEvents[widget.eventIndex].attendeeLimit}'),
            onTap: () {},
          ),ListTile(
           
             title: Text('Start Time', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text('${widget.model.displayedEvents[widget.eventIndex].startDateTime}'),
            onTap: () {},
          ),ListTile(
           
             title: Text('End Time', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text('${widget.model.displayedEvents[widget.eventIndex].endDateTime}'),
            onTap: () {},
          ),ListTile(
            
             title: Text('Hosts ID', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text('${widget.model.displayedEvents[widget.eventIndex].hostID}'),
            onTap: () {},
          ),ListTile(
           
             title: Text('Contact Host', style: TextStyle(fontWeight: FontWeight.bold),),
             subtitle: Text('${widget.model.displayedEvents[widget.eventIndex].hostEmail}'),
            onTap: () {},
          ),
      
      Center(
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
      
      ]
      
    ),
    );
  }
}
