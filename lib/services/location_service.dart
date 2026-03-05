// lib/services/location_service.dart
import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'storage_service.dart';
import 'webrtc_service.dart';

class LocationService {
  final WebRTCService webrtc;
  final Battery _battery = Battery();
  Timer? _timer;

  LocationService(this.webrtc);

  Future<void> start() async {
    await Geolocator.requestPermission();

    _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      final pos = await Geolocator.getCurrentPosition();
      final level = await _battery.batteryLevel;

      final now = DateTime.now().millisecondsSinceEpoch;

      webrtc.sendData({
        "type": "location",
        "payload": {
          "lat": pos.latitude,
          "lng": pos.longitude,
          "battery": level / 100.0,
          "timestamp": now,
        }
      });

      final locations = await StorageService.getLocations();
      locations["self"] = {
        "lat": pos.latitude,
        "lng": pos.longitude,
        "battery": level / 100.0,
        "timestamp": now,
      };
      await StorageService.saveLocations(locations);

      if (level <= 20) {
        webrtc.sendData({
          "type": "battery_low",
          "payload": {
            "battery": level / 100.0,
            "timestamp": now,
          }
        });
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
