import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../Model/SensorData.dart';
import '../Service/api_service.dart';

class SensorHistory extends StatefulWidget {
  const SensorHistory({super.key});

  @override
  State<SensorHistory> createState() => SensorHistoryState();
}

class SensorHistoryState extends State<SensorHistory> {
  late Future<List<SensorData>> _sensorDataFuture;

  @override
  void initState() {
    super.initState();
    _loadSensorData();
  }

  void _loadSensorData() {
    setState(() {
      _sensorDataFuture = ApiService().getSensorData(); // IP à adapter
    });
  }
  void refreshData() {
    _loadSensorData();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SensorData>>(
      future: _sensorDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune donnée disponible.'));
        }

        final data = snapshot.data!;
        final tempSpots = data.map((e) {
          final x = e.timestamp.millisecondsSinceEpoch.toDouble();
          return FlSpot(x, e.temperature);
        }).toList();

        return SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Temp.')),
              DataColumn(label: Text('Humidité')),
              DataColumn(label: Text('Heure')),
            ],
            rows: data.map((sensor) {
              return DataRow(cells: [
                DataCell(Text(sensor.deviceId)),
                DataCell(Text('${sensor.temperature} °C')),
                DataCell(Text('${sensor.humidity} %')),
                DataCell(Text(DateFormat.Hm().format(sensor.timestamp.toLocal()))),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
