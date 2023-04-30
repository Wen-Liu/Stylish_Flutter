import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMap();
}

class _GoogleMap extends State<GoogleMapPage> {
  late GoogleMapController mapController;
  Location _location = Location();
  Set<Marker> _markers = {};

  final LatLng _center = const LatLng(25.038363, 121.532402);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng latLng) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Your Location',
          snippet:
              'Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}',
        ),
      ));
    });
  }

  void _getCurrentLocation() async {
    LocationData? locationData = await _location.getLocation();
    LatLng currentLatLng =
        LatLng(locationData.latitude!, locationData.longitude!);
    mapController.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 15));
    _addMarker(currentLatLng);
  }

  //
  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _markers.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
