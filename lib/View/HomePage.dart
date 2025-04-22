import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/Sensor.dart';
import '../Service/api_service.dart';
import 'SensorHome.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Sensor>> _sensorFuture;

  @override
  void initState() {
    super.initState();
    _loadSensorData();
  }

  void _loadSensorData() {
    setState(() {
      _sensorFuture = ApiService().getSensor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CI/CD Mobile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () {
          _loadSensorData();
        },
        child: const Icon(Icons.refresh),
      ),
      body: FutureBuilder<List<Sensor>>(
        future: _sensorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final sensors = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cartes par ligne
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            itemCount: sensors.length,
            itemBuilder: (context, index) {
              final sensor = sensors[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SensorHome(sensor: sensor),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📟 ${sensor.deviceId}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("🌡️ Température: ${sensor.temperature}°C"),
                        Text("💧 Humidité: ${sensor.humidity}%"),
                        const SizedBox(height: 5),
                        Text('🕒 : ${DateFormat('dd-MM-yy HH:mm:ss').format(sensor.timestamp.toLocal())}')
                      ],
                    ),
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
