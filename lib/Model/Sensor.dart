class Sensor {
  final String deviceId;
  final double temperature;
  final double humidity;
  final DateTime timestamp;
  final String type;

  Sensor({
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
    required this.type,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      deviceId: json['device_id'],
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'device_id': deviceId,
    'temperature': temperature,
    'humidity': humidity,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
  };
}
