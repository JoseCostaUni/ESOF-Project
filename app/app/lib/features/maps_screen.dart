import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key});

  @override
  State<StatefulWidget> createState() => MapsPage();
}

class MapsPage extends State<MapsScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(41.15, -8.61024),
    zoom: 11.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
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
        ],
      ),
    );
  }
}
