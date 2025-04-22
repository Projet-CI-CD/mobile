import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../Model/SensorData.dart';
import '../Service/api_service.dart';

class SensorDashboard extends StatefulWidget {
  const SensorDashboard({super.key});

  @override
  State<SensorDashboard> createState() => SensorDashboardState();
}

class SensorDashboardState extends State<SensorDashboard> {
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
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, _) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Text(DateFormat.Hm().format(date), style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: tempSpots,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.blue,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
