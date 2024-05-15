import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapsScreen extends StatefulWidget {
  final List<String> locationNames;

  const MapsScreen({Key? key, required this.locationNames}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapsPage(locationNames: locationNames);
}

class MapsPage extends State<MapsScreen> {
  final List<String> locationNames;
  late GoogleMapController _mapController;
  late LatLng _currentPosition;

  MapsPage({required this.locationNames});

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _goToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController.animateCamera(CameraUpdate.newLatLng(
      LatLng(position.latitude, position.longitude),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<Marker>>(
            future: _createMarkers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                // Verifica se há marcadores
                if (snapshot.data?.isNotEmpty ?? false) {
                  LatLng initialPosition = snapshot.data![0].position;
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(target: initialPosition, zoom: 11.5),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: Set<Marker>.of(snapshot.data ?? []),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  );
                } else {
                  // Caso não haja marcadores, exibe uma posição padrão
                  return Center(
                    child: Text('No markers found'),
                  );
                }
              }
            },
          ),
          Positioned(
            top: 40.0,
            left: 16.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Marker>> _createMarkers() async {
    List<Future<Marker>> markerFutures = [];
    for (String locationName in locationNames) {
      markerFutures.add(_createMarker(locationName));
    }
    return Future.wait(markerFutures);
  }

  Future<Marker> _createMarker(String locationName) async {
    List<Location> locations = await locationFromAddress(locationName);
    if (locations.isNotEmpty) {
      final location = locations.first;
      return Marker(
        markerId: MarkerId(locationName),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: locationName,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      );
    } else {
      throw Exception('Location not found: $locationName');
    }
  }
}
