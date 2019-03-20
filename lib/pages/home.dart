import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../scoped_models/main_model.dart';

class HomePage extends StatefulWidget {
  final MainModel model;
  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // the controller that controls the google map
  Completer<GoogleMapController> _mapController = Completer();

  var _currentLocation = <String, double>{};
  var _location = Location();
  LatLng _currentLocationLatLng;

  @override
  void initState() {
    // by default location is queens
    _currentLocationLatLng = LatLng(44.2247881, -76.4995687);
    // get the user location when map loads
    _fetchUserLocation(moveCamera: true);
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
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentLocationLatLng,
            zoom: 14,
          ),
          myLocationEnabled: true,
        ),
        Positioned(
          bottom: 15.0,
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
}
