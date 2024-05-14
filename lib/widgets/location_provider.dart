import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends InheritedWidget {
  final LatLng currentLocation;

  const LocationProvider({super.key, required this.currentLocation, required super.child});

  @override
  bool updateShouldNotify(LocationProvider oldWidget) {
    return currentLocation != oldWidget.currentLocation;
  }

  static LocationProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocationProvider>();
  }
}