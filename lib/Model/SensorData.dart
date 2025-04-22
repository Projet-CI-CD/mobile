class SensorData {
  final int id;
  final String deviceId;
  final double temperature;
  final double humidity;
  final DateTime timestamp;
  final String type;

  SensorData({
    required this.id,
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
    required this.type,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'],
      deviceId: json['device_id'],
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'device_id': deviceId,
    'temperature': temperature,
    'humidity': humidity,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
  };
}
