// lib/pages/family_page.dart
import 'package:flutter/material.dart';
import 'qr_scan_page.dart';
import '../services/signal_service.dart';
import '../services/webrtc_service.dart';
import '../services/location_service.dart';
import 'map_page.dart';
import 'chat_page.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  String? groupId;
  String? signalUrl;
  late SignalService signal;
  WebRTCService? webrtc;
  LocationService? locationService;

  @override
  void initState() {
    super.initState();
    signal = SignalService();
  }

  Future<void> _joinFamily() async {
    final payload = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrScanPage()),
    );

    if (payload == null) return;

    groupId = payload["groupId"];
    signalUrl = payload["signal"];

    await signal.connect(signalUrl!, groupId!);

    webrtc = WebRTCService(signal);
    await webrtc!.initAsCaller();

    locationService = LocationService(webrtc!);
    await locationService!.start();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (groupId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("FamilyCompass")),
        body: Center(
          child: ElevatedButton(
            onPressed: _joinFamily,
            child: const Text("扫码加入家庭"),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("FamilyCompass"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: "地图"),
              Tab(icon: Icon(Icons.chat), text: "聊天"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const MapPage(),
            ChatPage(webrtc: webrtc!),
          ],
        ),
      ),
    );
  }
}
