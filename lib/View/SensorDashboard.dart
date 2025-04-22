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
        final humiditySpots = data.map((e) {
          final x = e.timestamp.millisecondsSinceEpoch.toDouble();
          return FlSpot(x, e.humidity);
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              Text("Température"),
              Container(
                padding: EdgeInsets.all(10),
                height: 300.0, // Fixed height for the chart
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          )
                      ),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          )
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          getTitlesWidget: (value, _) {
                            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                            return Text(
                              DateFormat('HH:mm').format(date), // Affiche uniquement les heures et minutes
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            // Affiche la température sur l'axe Y
                            return Text(
                              '${value.toStringAsFixed(1)}', // Format de la température (1 chiffre après la virgule)
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: tempSpots, // tempSpots contiendra les données de température
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),

              Text("Humidité"),
              Container(
                padding: EdgeInsets.all(10),
                height: 300.0, // Fixed height for the chart
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          )
                      ),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          )
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          getTitlesWidget: (value, _) {
                            final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                            return Text(
                              DateFormat('HH:mm').format(date), // Affiche uniquement les heures et minutes
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            // Affiche la température sur l'axe Y
                            return Text(
                              '${value.toStringAsFixed(1)}', // Format de la température (1 chiffre après la virgule)
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: humiditySpots, // tempSpots contiendra les données de température
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.green,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        );
      },
    );
  }
}
