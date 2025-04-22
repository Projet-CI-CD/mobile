import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SensorDashboard.dart';
import 'SensorHistory.dart'; // Assurez-vous d'importer la page Historique

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final GlobalKey<SensorDashboardState> _dashboardKey = GlobalKey();
  final GlobalKey<SensorHistoryState> _historyKey = GlobalKey();

  late final List<Widget> _pages = [
    SensorDashboard(key: _dashboardKey),
    SensorHistory(key: _historyKey),  // Assurez-vous que cette page est correctement définie
    const Center(child: Text('Paramètres')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = _selectedIndex == 0 || _selectedIndex == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 0) {
            _dashboardKey.currentState?.refreshData();
          } else if (_selectedIndex == 1) {
            _historyKey.currentState?.refreshData();
          }
        },
        child: const Icon(Icons.refresh),
      )
          : null,
    );
  }
}
