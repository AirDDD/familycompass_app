import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as osm;
import 'package:amap_flutter_map/amap_flutter_map.dart' as amap;
import 'package:amap_flutter_base/amap_flutter_base.dart' as amap_base;

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
    // 默认中心点（北京天安门）
    final center = osm.LatLng(39.909187, 116.397451);

    // 如果用户填了高德 Key → 使用高德地图
    if (_amapKey != null && _amapKey!.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("家庭位置（高德）")),
        body: amap.AMapWidget(
          apiKey: amap_base.AMapApiKeyConfig(
            androidKey: _amapKey!,
            iosKey: _amapKey!,
          ),
          initialCameraPosition: amap.CameraPosition(
            target: amap_base.LatLng(center.latitude, center.longitude),
            zoom: 12,
          ),
        ),
      );
    }

    // 否则使用 OSM 免费地图
    return Scaffold(
      appBar: AppBar(title: const Text("家庭位置（OSM）")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.familycompass_app",
          ),
        ],
      ),
    );
  }
}
