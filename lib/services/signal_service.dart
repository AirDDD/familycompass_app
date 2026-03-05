// lib/services/signal_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'storage_service.dart';

typedef SignalHandler = void Function(Map<String, dynamic> data);

class SignalService {
  WebSocket? _ws;
  String? deviceId;
  String? groupId;
  SignalHandler? onSignal;

  Future<void> connect(String signalUrl, String groupId) async {
    deviceId ??= await StorageService.getDeviceId() ?? const Uuid().v4();
    await StorageService.saveDeviceId(deviceId!);

    this.groupId = groupId;

    _ws = await WebSocket.connect(signalUrl);

    _ws!.listen((msg) {
      try {
        final data = jsonDecode(msg);
        if (onSignal != null) {
          onSignal!(data);
        }
      } catch (_) {}
    });

    _ws!.add(jsonEncode({
      "type": "register",
      "deviceId": deviceId,
      "groupId": groupId
    }));
  }

  void sendSignal(Map<String, dynamic> data) {
    if (_ws == null) return;
    _ws!.add(jsonEncode(data));
  }
}
