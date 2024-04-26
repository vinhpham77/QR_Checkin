import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/theme.dart';

class GMap extends StatefulWidget {
  final double radius;
  final Function onLocationChanged;
  final LatLng? latLng;

  const GMap({super.key, required this.radius, required this.onLocationChanged, this.latLng});

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _getUserLocation();

    if (widget.latLng != null) {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.latLng.toString()),
          position: widget.latLng!,
          infoWindow: InfoWindow.noText,
        ),
      );

      _circles.add(
        Circle(
          circleId: CircleId(widget.latLng.toString()),
          center: widget.latLng!,
          radius: widget.radius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
    } else {
      _markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: _currentPosition!,
          infoWindow: InfoWindow.noText,
        ),
      );

      _circles.add(
        Circle(
          circleId: const CircleId('current'),
          center: _currentPosition!,
          radius: widget.radius,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
      child: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              markers: _markers,
              onTap: (LatLng latLng) {
                mapController.animateCamera(
                  CameraUpdate.newLatLng(latLng),
                );
                setState(() {
                  _markers.clear();
                  _markers.add(
                    Marker(
                      markerId: MarkerId(latLng.toString()),
                      position: latLng,
                      infoWindow: InfoWindow.noText
                    ),
                  );

                  _circles.clear();
                  _circles.add(
                    Circle(
                      circleId: CircleId(latLng.toString()),
                      center: latLng,
                      radius: widget.radius,
                      fillColor: Colors.blue.withOpacity(0.3),
                      strokeColor: Colors.blue,
                      strokeWidth: 1,
                    ),
                  );

                  widget.onLocationChanged(latLng);
                  setState(() {
                    _currentPosition = latLng;
                  });
                });
              },
              circles: _circles,
              buildingsEnabled: true,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.latLng ?? _currentPosition!,
                zoom: 18,
              ),
            ),
    );
  }

  void _getUserLocation() async {
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  LatLng? get selectedLocation {
    return _markers.isNotEmpty ? _markers.first.position : null;
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }
}
