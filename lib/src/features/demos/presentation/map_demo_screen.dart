import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapDemoScreen extends HookConsumerWidget {
  const MapDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Tokyo Station coordinates
    final initialPosition = useMemoized(() => const LatLng(35.6812, 139.7671));

    final markers = useState<Set<Marker>>({});
    final mapType = useState(MapType.normal);

    useEffect(() {
      // Add sample markers
      markers.value = {
        Marker(
          markerId: const MarkerId('tokyo_station'),
          position: const LatLng(35.6812, 139.7671),
          infoWindow: const InfoWindow(
            title: 'Tokyo Station',
            snippet: 'Main railway station',
          ),
        ),
        Marker(
          markerId: const MarkerId('tokyo_tower'),
          position: const LatLng(35.6586, 139.7454),
          infoWindow: const InfoWindow(
            title: 'Tokyo Tower',
            snippet: 'Iconic landmark',
          ),
        ),
        Marker(
          markerId: const MarkerId('shibuya'),
          position: const LatLng(35.6595, 139.7004),
          infoWindow: const InfoWindow(
            title: 'Shibuya Crossing',
            snippet: 'Famous intersection',
          ),
        ),
      };
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Demo'),
        actions: [
          PopupMenuButton<MapType>(
            icon: const Icon(Icons.layers),
            tooltip: 'Map Type',
            onSelected: (type) => mapType.value = type,
            itemBuilder: (context) => [
              const PopupMenuItem(value: MapType.normal, child: Text('Normal')),
              const PopupMenuItem(
                value: MapType.satellite,
                child: Text('Satellite'),
              ),
              const PopupMenuItem(value: MapType.hybrid, child: Text('Hybrid')),
              const PopupMenuItem(
                value: MapType.terrain,
                child: Text('Terrain'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 12,
              ),
              mapType: mapType.value,
              markers: markers.value,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              onMapCreated: (controller) {
                // Map controller is ready
              },
              onTap: (position) {
                // Add marker on tap
                final newMarkerId = MarkerId('marker_${markers.value.length}');
                final newMarker = Marker(
                  markerId: newMarkerId,
                  position: position,
                  infoWindow: InfoWindow(
                    title: 'Custom Marker',
                    snippet:
                        'Lat: ${position.latitude.toStringAsFixed(4)}, '
                        'Lng: ${position.longitude.toStringAsFixed(4)}',
                  ),
                );
                markers.value = {...markers.value, newMarker};
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Map Controls', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Normal'),
                      selected: mapType.value == MapType.normal,
                      onSelected: (selected) {
                        if (selected) mapType.value = MapType.normal;
                      },
                    ),
                    FilterChip(
                      label: const Text('Satellite'),
                      selected: mapType.value == MapType.satellite,
                      onSelected: (selected) {
                        if (selected) mapType.value = MapType.satellite;
                      },
                    ),
                    FilterChip(
                      label: const Text('Hybrid'),
                      selected: mapType.value == MapType.hybrid,
                      onSelected: (selected) {
                        if (selected) mapType.value = MapType.hybrid;
                      },
                    ),
                    FilterChip(
                      label: const Text('Terrain'),
                      selected: mapType.value == MapType.terrain,
                      onSelected: (selected) {
                        if (selected) mapType.value = MapType.terrain;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_sweep),
                        label: const Text('Clear Markers'),
                        onPressed: () {
                          markers.value = {};
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.add_location),
                        label: const Text('Reset Markers'),
                        onPressed: () {
                          markers.value = {
                            Marker(
                              markerId: const MarkerId('tokyo_station'),
                              position: const LatLng(35.6812, 139.7671),
                              infoWindow: const InfoWindow(
                                title: 'Tokyo Station',
                                snippet: 'Main railway station',
                              ),
                            ),
                            Marker(
                              markerId: const MarkerId('tokyo_tower'),
                              position: const LatLng(35.6586, 139.7454),
                              infoWindow: const InfoWindow(
                                title: 'Tokyo Tower',
                                snippet: 'Iconic landmark',
                              ),
                            ),
                            Marker(
                              markerId: const MarkerId('shibuya'),
                              position: const LatLng(35.6595, 139.7004),
                              infoWindow: const InfoWindow(
                                title: 'Shibuya Crossing',
                                snippet: 'Famous intersection',
                              ),
                            ),
                          };
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap on the map to add custom markers',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
