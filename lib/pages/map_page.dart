// lib/pages/map_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/storage_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<String, dynamic> _locations = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    _locations = await StorageService.getLocations();
    _buildMarkers();
  }

  void _buildMarkers() {
    final markers = <Marker>{};

    _locations.forEach((key, value) {
      final lat = value["lat"] as double;
      final lng = value["lng"] as double;
      final battery = (value["battery"] * 100).toInt();
      final ts = DateTime.fromMillisecondsSinceEpoch(value["timestamp"]);

      markers.add(
        Marker(
          markerId: MarkerId(key),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: key == "self" ? "我" : key,
            snippet: "电量: $battery%  时间: $ts",
          ),
        ),
      );
    });

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initial = _locations["self"];
    final center = initial != null
        ? LatLng(initial["lat"], initial["lng"])
        : const LatLng(35.6895, 139.6917);

    return Scaffold(
      appBar: AppBar(title: const Text("家庭地图")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: center, zoom: 12),
        markers: _markers,
        onMapCreated: (c) => _controller.complete(c),
      ),
    );
  }
}
