import 'dart:io';

import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

enum MapProvider { google, apple }

class MapWidget extends HookWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Tokyo Station coordinates
    const tokyoStation = LatLng(35.6812, 139.7671);

    return SizedBox(
      height: 300,
      child: Platform.isIOS
          ? _AppleMapView(initialPosition: tokyoStation)
          : _GoogleMapView(initialPosition: tokyoStation),
    );
  }
}

class _GoogleMapView extends HookWidget {
  const _GoogleMapView({required this.initialPosition});

  final LatLng initialPosition;

  @override
  Widget build(BuildContext context) {
    final markers = useState<Set<google.Marker>>({});

    useEffect(() {
      markers.value = {
        google.Marker(
          markerId: const google.MarkerId('tokyo_station'),
          position: google.LatLng(
            initialPosition.latitude,
            initialPosition.longitude,
          ),
          infoWindow: const google.InfoWindow(
            title: 'Tokyo Station',
            snippet: 'Main railway station',
          ),
        ),
        google.Marker(
          markerId: const google.MarkerId('tokyo_tower'),
          position: const google.LatLng(35.6586, 139.7454),
          infoWindow: const google.InfoWindow(
            title: 'Tokyo Tower',
            snippet: 'Iconic landmark',
          ),
        ),
      };
      return null;
    }, const []);

    return google.GoogleMap(
      initialCameraPosition: google.CameraPosition(
        target: google.LatLng(
          initialPosition.latitude,
          initialPosition.longitude,
        ),
        zoom: 12,
      ),
      markers: markers.value,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}

class _AppleMapView extends HookWidget {
  const _AppleMapView({required this.initialPosition});

  final LatLng initialPosition;

  @override
  Widget build(BuildContext context) {
    final annotations = useState<Set<apple.Annotation>>({});

    useEffect(() {
      annotations.value = {
        apple.Annotation(
          annotationId: apple.AnnotationId('tokyo_station'),
          position: apple.LatLng(
            initialPosition.latitude,
            initialPosition.longitude,
          ),
          infoWindow: apple.InfoWindow(
            title: 'Tokyo Station',
            snippet: 'Main railway station',
          ),
        ),
        apple.Annotation(
          annotationId: apple.AnnotationId('tokyo_tower'),
          position: apple.LatLng(35.6586, 139.7454),
          infoWindow: apple.InfoWindow(
            title: 'Tokyo Tower',
            snippet: 'Iconic landmark',
          ),
        ),
      };
      return null;
    }, const []);

    return apple.AppleMap(
      initialCameraPosition: apple.CameraPosition(
        target: apple.LatLng(
          initialPosition.latitude,
          initialPosition.longitude,
        ),
        zoom: 12,
      ),
      annotations: annotations.value,
      myLocationButtonEnabled: false,
    );
  }
}

// Common LatLng class for both platforms
class LatLng {
  const LatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}
