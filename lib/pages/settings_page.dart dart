import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _amapKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final key = await StorageService.getAmapKey();
    _amapKeyController.text = key ?? "";
    setState(() {});
  }

  Future<void> _save() async {
    await StorageService.saveAmapKey(_amapKeyController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("已保存高德 Key")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("设置")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amapKeyController,
              decoration: const InputDecoration(
                labelText: "高德地图 Key（可选）",
                hintText: "不填则使用免费地图",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: const Text("保存"),
            ),
          ],
        ),
      ),
    );
  }
}
