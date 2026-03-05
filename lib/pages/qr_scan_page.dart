// lib/pages/qr_scan_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  bool handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("扫码加入家庭")),
      body: MobileScanner(
        onDetect: (capture) {
          if (handled) return;
          handled = true;

          final raw = capture.barcodes.first.rawValue;
          if (raw == null) return;

          try {
            final payload = jsonDecode(raw);
            Navigator.pop(context, payload);
          } catch (_) {
            Navigator.pop(context, null);
          }
        },
      ),
    );
  }
}
