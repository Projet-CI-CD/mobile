import 'dart:convert';

import '../Model/Sensor.dart';
import '../Model/SensorData.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl ="http://34.163.42.77:3000/iot";

  ApiService();

  Future<List<SensorData>> getSensorData(Sensor sensor,{SensorData? last}) async {
    final response = await http.get(Uri.parse('$baseUrl/data?device_id=${sensor.deviceId}&last_id=${last?.id}')).timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      List<dynamic> dataJson = jsonDecode(response.body);
      return dataJson.map((e) => SensorData.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des données capteur');
    }
  }
  Future<List<Sensor>> getSensor() async {
    final response = await http.get(Uri.parse('$baseUrl')).timeout(Duration(seconds: 15));

    if (response.statusCode == 200) {
      List<dynamic> dataJson = jsonDecode(response.body);
      return dataJson.map((e) => Sensor.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des données capteur');
    }
  }
}