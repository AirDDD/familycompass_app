// lib/pages/chat_page.dart
import 'package:flutter/material.dart';
import '../services/webrtc_service.dart';
import '../services/storage_service.dart';

class ChatPage extends StatefulWidget {
  final WebRTCService webrtc;
  const ChatPage({super.key, required this.webrtc});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    widget.webrtc.onData = _onData;
  }

  Future<void> _loadMessages() async {
    _messages = await StorageService.getMessages();
    setState(() {});
  }

  void _onData(Map<String, dynamic> data) async {
    if (data["type"] == "chat") {
      _messages.add({
        "from": data["from"] ?? "unknown",
        "text": data["payload"]["text"],
        "ts": DateTime.now().millisecondsSinceEpoch,
      });
      await StorageService.saveMessages(_messages);
      setState(() {});
    } else if (data["type"] == "location") {
      final locations = await StorageService.getLocations();
      locations[data["from"] ?? "member"] = {
        "lat": data["payload"]["lat"],
        "lng": data["payload"]["lng"],
        "battery": data["payload"]["battery"],
        "timestamp": data["payload"]["timestamp"],
      };
      await StorageService.saveLocations(locations);
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.webrtc.sendData({
      "type": "chat",
      "payload": {"text": text}
    });

    _messages.add({
      "from": "me",
      "text": text,
      "ts": DateTime.now().millisecondsSinceEpoch,
    });
    await StorageService.saveMessages(_messages);

    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("家庭聊天")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final m = _messages[i];
                final isMe = m["from"] == "me";
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      m["text"],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "输入消息..."),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _send,
              )
            ],
          )
        ],
      ),
    );
  }
}
