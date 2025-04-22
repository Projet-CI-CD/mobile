import 'dart:convert';

import '../Model/SensorData.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl ="http://127.0.0.1/";

  ApiService();

  Future<List<SensorData>> getSensorData() async {
    final response = await http.get(Uri.parse('$baseUrl/iot'));

    if (response.statusCode == 200) {
      List<dynamic> dataJson = jsonDecode(response.body);
      return dataJson.map((e) => SensorData.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des données capteur');
    }
  }
}