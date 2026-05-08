class ModuleReading {
  final DateTime? ts;
  final double? temperatureC;
  final double? humidityPct;
  final double? ph;
  final double? ecMsCm;
  final double? tdsPpm;
  final double? tankLevelPct;

  ModuleReading({
    this.ts,
    this.temperatureC,
    this.humidityPct,
    this.ph,
    this.ecMsCm,
    this.tdsPpm,
    this.tankLevelPct,
  });

  factory ModuleReading.fromJson(Map<String, dynamic> json) {
    return ModuleReading(
      ts: json['ts'] != null ? DateTime.tryParse(json['ts'].toString()) : null,
      temperatureC: json['temperature_c']?.toDouble(),
      humidityPct: json['humidity_pct']?.toDouble(),
      ph: json['ph']?.toDouble(),
      ecMsCm: json['ec_ms_cm']?.toDouble(),
      tdsPpm: json['tds_ppm']?.toDouble(),
      tankLevelPct: json['tank_level_pct']?.toDouble(),
    );
  }
}