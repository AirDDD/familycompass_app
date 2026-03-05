import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyServer = "server_url";
  static const _keyDeviceId = "device_id";
  static const _keyLocations = "member_locations";
  static const _keyMessages = "chat_messages";
  static const _keyAmap = "amap_key";

  // 保存服务器地址
  static Future<void> saveServer(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyServer, url);
  }

  static Future<String?> getServer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyServer);
  }

  // 保存设备 ID
  static Future<void> saveDeviceId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeviceId, id);
  }

  static Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceId);
  }

  // 保存位置
  static Future<void> saveLocations(Map<String, dynamic> locations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocations, jsonEncode(locations));
  }

  static Future<Map<String, dynamic>> getLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyLocations);
    if (raw == null) return {};
    return jsonDecode(raw);
  }

  // 保存聊天记录
  static Future<void> saveMessages(List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMessages, jsonEncode(messages));
  }

  static Future<List<Map<String, dynamic>>> getMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyMessages);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  // 保存高德 Key
  static Future<void> saveAmapKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAmap, key);
  }

  static Future<String?> getAmapKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAmap);
  }
}
