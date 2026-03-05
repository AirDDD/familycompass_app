import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/family_service.dart';

class QrGeneratePage extends StatelessWidget {
  const QrGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    final familyId = FamilyService.familyId ?? "未知";

    return Scaffold(
      appBar: AppBar(title: const Text("家庭二维码")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: familyId,
              version: QrVersions.auto,
              size: 240,
            ),
            const SizedBox(height: 20),
            Text(
              "家庭ID：$familyId",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
