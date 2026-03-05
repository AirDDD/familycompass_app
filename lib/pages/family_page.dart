import 'package:flutter/material.dart';
import '../services/family_service.dart';
import 'qr_generate_page.dart';
import 'qr_scan_page.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _joinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final familyId = FamilyService.familyId;
    final members = FamilyService.getMembers();

    return Scaffold(
      appBar: AppBar(title: const Text("家庭")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: familyId == null
            ? buildNoFamilyUI()
            : buildFamilyUI(familyId, members),
      ),
    );
  }

  // 未加入家庭时的 UI
  Widget buildNoFamilyUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("你的名字：", style: TextStyle(fontSize: 16)),
        TextField(controller: _nameController),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              setState(() {
                FamilyService.createFamily(_nameController.text);
              });
            }
          },
          child: const Text("创建家庭"),
        ),

        const SizedBox(height: 40),
        const Text("加入家庭：", style: TextStyle(fontSize: 16)),
        TextField(
          controller: _joinController,
          decoration: const InputDecoration(hintText: "输入家庭ID"),
        ),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _joinController.text.isNotEmpty) {
              setState(() {
                FamilyService.joinFamily(
                    _joinController.text, _nameController.text);
              });
            }
          },
          child: const Text("加入家庭"),
        ),
      ],
    );
  }

