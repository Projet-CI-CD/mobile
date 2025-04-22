import 'dart:convert';

import '../Model/SensorData.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl ="http://10.6.13.176:3000";

  ApiService();

  Future<List<SensorData>> getSensorData({SensorData? last}) async {
    if(last==null){
      final response = await http.get(Uri.parse('$baseUrl/iot')).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> dataJson = jsonDecode(response.body);
        return dataJson.map((e) => SensorData.fromJson(e)).toList();
      } else {
        throw Exception('Erreur lors du chargement des données capteur');
      }
    }
    else{
      final response = await http.get(Uri.parse('$baseUrl/iot?last_id=${last.id}')).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> dataJson = jsonDecode(response.body);
        return dataJson.map((e) => SensorData.fromJson(e)).toList();
      } else {
        throw Exception('Erreur lors du chargement des données capteur');
      }
    }


  }
}