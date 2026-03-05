import 'package:flutter/material.dart';

void main() {
  runApp(const FamilyCompassApp());
}

class FamilyCompassApp extends StatelessWidget {
  const FamilyCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FamilyCompass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FamilyCompass Demo'),
      ),
      body: const Center(
        child: Text(
          '这是一个最小可打包的 Flutter App。\n'
          '后面我们会在这里接入你的 WebRTC / 聊天 / 服务器地址输入。',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
