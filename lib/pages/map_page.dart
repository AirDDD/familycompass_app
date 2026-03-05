// lib/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import '../services/storage_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Map<String, dynamic> _locations = {};
  String? _amapKey;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _locations = await StorageService.getLocations();
    _amapKey = await StorageService.getAmapKey(); // 用户是否填了高德 key
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final self = _locations["self"];
    final center = self != null
        ? LatLng(self["lat"], self["lng"])
        : const LatLng(39.909187, 116.397451);

    // 如果用户填了高德 key → 用高德地图
    if (_amapKey != null && _amapKey!.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("家庭地图（高德）")),
        body: AMapWidget(
          apiKey: AMapApiKey(
            androidKey: _amapKey!,
            iosKey: _amapKey!,
          ),
          initialCameraPosition: CameraPosition(
            target: LatLng(center.latitude, center.longitude),
            zoom: 14,
          ),
        ),
      );
    }

    // 默认：OSM 免费地图
    return Scaffold(
      appBar: AppBar(title: const Text("家庭地图（免费）")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
        ],
      ),
    );
  }
}
