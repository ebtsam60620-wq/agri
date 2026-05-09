part of 'field_conditions_controller.dart';

class FieldConditionsState {
  final ModuleReading? latestReading;
  final List<SensorStatus> sensors;
  final Requestenum systemStatus;
  final Requestenum sensorStatus;
  final String? errorMessage;

  FieldConditionsState({
    this.latestReading,
    this.sensors = const [],
    this.systemStatus = Requestenum.init,
    this.sensorStatus = Requestenum.init,
    this.errorMessage,
  });

  FieldConditionsState copyWith({
    ModuleReading? latestReading,
    List<SensorStatus>? sensors,
    Requestenum? systemStatus,
    Requestenum? sensorStatus,
    String? errorMessage,
  }) {
    return FieldConditionsState(
      latestReading: latestReading ?? this.latestReading,
      sensors: sensors ?? this.sensors,
      systemStatus: systemStatus ?? this.systemStatus,
      sensorStatus: sensorStatus ?? this.sensorStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
