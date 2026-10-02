import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Centralized Google Maps configuration and corridor coordinates for Sendalli.
class MapConstants {
  MapConstants._();

  /// Google Maps API Key canonically defined from key.md
  static const String googleMapsApiKey = 'AIzaSyC4xgutAJjv9z8vw4ZHRsqx2pvvMQxa_oE';

  /// Default Warri & Effurun Corridor Focus (Delta State, Nigeria)
  static const LatLng warriEffurunCenter = LatLng(5.54423, 5.76027);
  static const double defaultZoom = 14.5;

  /// Sample Corridor Key Waypoints for Keke commercial routes
  static const LatLng enerhenJunction = LatLng(5.5348, 5.7645);
  static const LatLng jakpaJunction = LatLng(5.5482, 5.7720);
  static const LatLng refineryRoad = LatLng(5.5601, 5.7890);
  static const LatLng effurunRoundabout = LatLng(5.5520, 5.7790);
}
