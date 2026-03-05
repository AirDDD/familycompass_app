import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/family_service.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("扫码加入家庭")),
      body: MobileScanner(
        onDetect: (capture) {
          if (_handled) return;
          _handled = true;

          final barcode = capture.barcodes.first;
          final code = barcode.rawValue;

          if (code != null && code.length == 6) {
            Navigator.pop(context, code);
          } else {
            Navigator.pop(context, null);
          }
        },
      ),
    );
  }
}
