import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model/Sensor.dart';
import 'SensorDashboard.dart';
import 'SensorHistory.dart'; // Assurez-vous d'importer la page Historique

class SensorHome extends StatefulWidget {
  const SensorHome({super.key, required this.sensor});
  final Sensor sensor;

  @override
  State<SensorHome> createState() => _SensorHomeState();
}

class _SensorHomeState extends State<SensorHome> {
  int _selectedIndex = 1;

  final GlobalKey<SensorDashboardState> _dashboardKey = GlobalKey();
  final GlobalKey<SensorHistoryState> _historyKey = GlobalKey();

  late final List<Widget> _pages = [
    const Center(child: Text('Retour')),
    SensorDashboard(sensor:widget.sensor, key: _dashboardKey),
    SensorHistory(sensor:widget.sensor, key: _historyKey),  // Assurez-vous que cette page est correctement définie
  ];

  void _onItemTapped(int index) {
    if(index == 0){
      Navigator.pop(context);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = _selectedIndex == 1 || _selectedIndex == 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sensor.deviceId),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'Retour'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historique')
        ],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 1) {
            _dashboardKey.currentState?.refreshData();
          } else if (_selectedIndex == 2) {
            _historyKey.currentState?.refreshData();
          }
        },
        child: const Icon(Icons.refresh),
      )
          : null,
    );
  }
}
