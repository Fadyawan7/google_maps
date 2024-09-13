import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  //................................................. postion camera.....................
  // static final CameraPosition position =
  //     CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 14);

  //................................................. variables.....................
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  LatLng initialCameraPosition = LatLng(30.3753, 69.3451);

  //................................................. markers.....................

  final List<Marker> marker = [];

  List<Marker> list = [
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(31.476671, 74.301437),
        infoWindow: InfoWindow(title: 'My current location')),
  ];

  @override
  void initState() {
    super.initState();

    marker.addAll(list);
    getCurrentLocation();
  }
  //......................................get curent location///////........................

  void getCurrentLocation() async {
    bool _servicesenabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

//...............................Open GPS........................................................
    _servicesenabled = await location.serviceEnabled();
    if (!_servicesenabled) {
      _servicesenabled = await location.requestService();
      if (!_servicesenabled) {
        return;
      }
      //.....................................recheck permission..................................................
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.granted) {
          return;
        }
      }
      //..................................get current postion................................

      locationData = await location.getLocation();
      setState(() {
        initialCameraPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: initialCameraPosition, zoom: 14)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      initialCameraPosition: CameraPosition(target: initialCameraPosition,zoom: 14),
      myLocationEnabled: true,
      markers: Set<Marker>.of(marker),
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
    ));
  }
}
