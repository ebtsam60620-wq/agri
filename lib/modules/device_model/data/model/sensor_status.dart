class SensorStatus {
  final String sensorType;
  final String status;
  final DateTime? lastSeenAt;
  final String? lastValueText;

  SensorStatus({
    required this.sensorType,
    required this.status,
    this.lastSeenAt,
    this.lastValueText,
  });

  factory SensorStatus.fromJson(Map<String, dynamic> json) {
    return SensorStatus(
      sensorType: json['sensor_type'].toString(),
      status: json['status'].toString(),
      lastSeenAt: json['last_seen_at'] != null ? DateTime.tryParse(json['last_seen_at'].toString()) : null,
      lastValueText: json['last_value_text']?.toString(),
    );
  }
}