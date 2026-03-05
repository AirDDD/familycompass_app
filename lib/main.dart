import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/family_page.dart';
import 'pages/settings_page.dart';

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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MapPage(),
    FamilyPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "地图",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "家庭",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "设置",
          ),
        ],
      ),
    );
  }
}
