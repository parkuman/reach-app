import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../scoped_models/main_model.dart';
import '../models/event.dart';

class EventDetailsPage extends StatefulWidget {
  final MainModel model;
  final int eventIndex;
  EventDetailsPage(this.model, {this.eventIndex});

  @override
  State<StatefulWidget> createState() {
    return _EventDetailsPageState();
  }
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool showGoogleMap = true;
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> marker = {};
  LatLng eventLatLng;
  Event event;

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  @override
  void initState() {
    setState(() {
      event = widget.model.displayedEvents[widget.eventIndex];
      marker = {
        Marker(
            markerId:
                MarkerId(widget.model.displayedEvents[widget.eventIndex].id),
            position: LatLng(event.latitude, event.longitude)),
      };
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    event = widget.model.displayedEvents[widget.eventIndex];
    // prints the attendee list nicer than [name,name,name]
    String attendeesList = '';
    event.attendees.forEach((attendee) {
      attendeesList = attendeesList + '$attendee\n';
    });

    eventLatLng = LatLng(event.latitude, event.longitude);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          bool isGoing =
              event.attendees.contains(model.authenticatedUser.email);
          bool maxCapacity = event.attendees.length == event.attendeeLimit;
          if (model.isLoading) {
            return CircularProgressIndicator();
          }
          if (isGoing) {
            return RaisedButton(
              child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_off,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text('CANCEL',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                setState(() {
                  model.reachEvent(model.displayedEvents[widget.eventIndex]);
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
            );
          } else if (maxCapacity) {
            return RaisedButton(
              child: Container(
                alignment: Alignment.center,
                width: 130.0,
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.block,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text('EVENT FULL',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              color: Colors.red,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
            );
          } else {
            return RaisedButton(
              child: Container(
                alignment: Alignment.center,
                width: 90,
                height: 50.0,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text('REACH',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                setState(() {
                  model.reachEvent(model.displayedEvents[widget.eventIndex]);
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
            );
          }
        },
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Theme.of(context).accentColor,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${event.title}',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              background: Image.asset(
                '${event.image}',
                fit: BoxFit.cover,
                color: Colors.black,
                colorBlendMode: BlendMode.softLight,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ListTile(
                  title: Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${event.description}'),
                  onTap: () {},
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${event.location}'),
                      trailing: Icon(Icons.location_on),
                      onTap: () {
                        setState(() {
                          showGoogleMap = !showGoogleMap;
                          print(showGoogleMap);
                        });
                      },
                    ),
                    showGoogleMap
                        ? Container(
                            height: 250,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                rotateGesturesEnabled: false,
                                scrollGesturesEnabled: false,
                                zoomGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: eventLatLng,
                                  zoom: 14.5,
                                ),
                                markers: marker,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                ListTile(
                  title: Text(
                    'Attendees',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('$attendeesList'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Max Attendees',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(event.attendeeLimit == -1
                      ? 'unlimited'
                      : '${event.attendeeLimit}'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Start Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      '${DateFormat.EEEE().add_MMMd().format(event.startDateTime)}, ${DateFormat.jm().format(event.startDateTime)}'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'End Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      '${DateFormat.EEEE().add_MMMd().format(event.startDateTime)}, ${DateFormat.jm().format(event.startDateTime)}'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    'Contact Host',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${event.hostEmail}'),
                  onTap: () {},
                ),
                Container(height: 100.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
