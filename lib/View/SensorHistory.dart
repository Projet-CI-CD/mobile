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
  final List<SensorData> _sensorData = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadSensorData();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadSensorData();
    }
  }

  Future<void> _loadSensorData() async {
    setState(() => _isLoadingMore = true);

    try {
      final lastItem = _sensorData.isNotEmpty ? _sensorData.last : null;
      final newData = await ApiService().getSensorData(last: lastItem);

      if (newData.isNotEmpty) {
        setState(() {
          _sensorData.addAll(newData);
        });
      }
    } catch (e) {
      // Optionnel : afficher une erreur
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void refreshData() {
    _sensorData.clear();
    _loadSensorData();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _sensorData.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _sensorData.length) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ));
        }

        final sensor = _sensorData[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            title: Text('ID : ${sensor.deviceId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Température : ${sensor.temperature} °C'),
                Text('Humidité : ${sensor.humidity} %'),
                Text('Type : ${sensor.type}'),
                Text('Date : ${DateFormat('dd-MM-yy HH:mm:ss').format(sensor.timestamp.toLocal())}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
