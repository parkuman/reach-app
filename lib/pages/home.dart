import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  static const LatLng _initialCameraPosition =
      const LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initialCameraPosition,
            zoom: 14,
          ),
        ),
        
      ],
    );
  }
}
