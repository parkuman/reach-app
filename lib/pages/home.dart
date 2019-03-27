import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rubber/rubber.dart';

import '../scoped_models/main_model.dart';
import '../widgets/advertisement.dart';

class HomePage extends StatefulWidget {
  final MainModel model;
  final Function onDetailsButton;
  HomePage({this.model, this.onDetailsButton});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // the controller that controls the google map
  Completer<GoogleMapController> _mapController = Completer();
  var _currentLocation = <String, double>{};
  var _location = Location();
  LatLng _currentLocationLatLng;
  Set<Marker> _markers = {};

  // controllers for the bottom sliding page and for the scrolling of that page and its contents
  RubberAnimationController _rubberAnimationController;
  ScrollController _scrollController = ScrollController();
  bool collapseBottomSheet = false;

  @override
  void initState() {
    // by default location is queens
    _currentLocationLatLng = LatLng(44.2247881, -76.4995687);
    // get the user location when map loads
    _fetchUserLocation(moveCamera: true);

    // create the settings of the moveable bottom page using a pre-made widget
    _buildRubberAnimationController();

    // wait 3 seconds to enable to "autohide" feature of scrolling on the map. This makes the bottom sheet appear half way up when the app starts
    Future.delayed(Duration(seconds: 3), () {
      //set all the map markers
      _setMapMarkers();
      collapseBottomSheet = true;
    });

    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void _fetchUserLocation({moveCamera = false}) async {
    try {
      _currentLocation = await _location.getLocation();
      _currentLocationLatLng =
          LatLng(_currentLocation['latitude'], _currentLocation['longitude']);
      // if moveCamera is true, then run a function to move the camera to the users location
      if (moveCamera) _moveCamera(latLng: _currentLocationLatLng, zoom: 14.0);
    } catch (e) {
      _currentLocation = null;
    }
  }

  void _setMapMarkers() {
    _markers = {};
    setState(() {
      for (int i = 0; i < widget.model.allEvents.length; i++) {
        _markers.add(Marker(
          markerId: MarkerId(widget.model.allEvents[i].id),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(widget.model.allEvents[i].latitude,
              widget.model.allEvents[i].longitude),
          infoWindow: InfoWindow(
            title: widget.model.allEvents[i].title,
            snippet: widget.model.allEvents[i].location,
          ),
        ));
      }
    });
  }

  Future<void> _moveCamera(
      {LatLng latLng,
      double tilt = 0.0,
      double zoom = 0.0,
      double bearing = 0.0}) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          tilt: tilt,
          zoom: zoom,
          bearing: bearing,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: Container(
        child: RubberBottomSheet(
          scrollController: _scrollController,
          lowerLayer: _buildLowerLayer(),
          upperLayer: _buildUpperLayer(),
          animationController: _rubberAnimationController,
        ),
      ),
    );
  }

  void _collapseBottomSheet() {
    _rubberAnimationController.collapse();
    _scrollController.jumpTo(0.0);
  }

  void _buildRubberAnimationController() {
    _rubberAnimationController = RubberAnimationController(
        vsync: this,
        dismissable: false, // GO AWAY
        initialValue:
            0.3, // to make the bottom sheet load up at about 30% of the screen height (just like the half bound value)
        halfBoundValue: AnimationControllerValue(percentage: 0.3),
        upperBoundValue: AnimationControllerValue(percentage: 1.0),
        lowerBoundValue: AnimationControllerValue(percentage: 0.05),
        springDescription: SpringDescription.withDampingRatio(
          mass: 1,
          stiffness: Stiffness.LOW,
          ratio: DampingRatio.NO_BOUNCY,
        ),
        duration: Duration(milliseconds: 200));
  }

  // THE ENTIRETY OF THE HOME PAGE BENEATH THE SLIDEY MOVING BOTTOM SHEET, this holds a stack with the google map and any of its buttons
  Widget _buildLowerLayer() {
    _setMapMarkers();

    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          onCameraMoveStarted: () {
            if (collapseBottomSheet) {
              _collapseBottomSheet();
            }
          },
          initialCameraPosition: CameraPosition(
            target: _currentLocationLatLng,
            zoom: 14,
          ),
          myLocationEnabled: true,
        ),
        Positioned(
          bottom: 55.0,
          right: 15.0,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.location_searching),
            onPressed: () =>
                _moveCamera(latLng: _currentLocationLatLng, tilt: 30, zoom: 17),
          ),
        ),
      ],
    );
  }

  // everything that is contained within the sliding bottom sheet (for this app it is a scrollable list of events)
  Widget _buildUpperLayer() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          //TOP BIT WITH LITTLE SCROLL BAR THING
          Container(
            padding: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            height: 55,
            width: MediaQuery.of(context).size.width - 10,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 50.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                Container(height: 20.0),
                Text('Nearby Events',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          //LISTVIEW
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width - 10,
            height: MediaQuery.of(context).size.height - 15.0,
            child: _buildEventsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return index % 4 == 0
                ? Column(
                    children: <Widget>[Divider(), Advertisement(), Divider()],
                  )
                : Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => widget.onDetailsButton(index),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                leading: CircleAvatar(
                  // backgroundImage: NetworkImage(model.allEvents[index].image),
                  backgroundImage: AssetImage("assets/event.jpg"),
                  radius: 30.0,
                ),
                title: Text(model.allEvents[index].title),
                subtitle:
                    Text('Description: ${model.allEvents[index].description}'),
                trailing: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () {
                    _moveCamera(
                      latLng: LatLng(model.allEvents[index].latitude,
                          model.allEvents[index].longitude),
                      tilt: 45.0,
                      zoom: 17.0,
                    );
                  },
                ),
              ),
            );
          },
          itemCount: model.allEvents.length,
        );
      },
    );
  }
}
