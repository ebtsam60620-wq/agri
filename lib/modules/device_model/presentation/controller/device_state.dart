part of 'device_controller.dart';

enum DeviceFlow {
  loadModules,
  linkingModule,
  updatingModule,
  idle;
}


class DeviceState {
  final List<DeviceModule> devices;
  final DeviceModule? activeModule;
  final Requestenum status;
  final DeviceFlow flow;
  final String? errorMessage;
  
  // Private-set logic: we use a Set to track which IDs are currently performing an action
  final Set<int> loadingIds; 
  final int automationLimit;

  DeviceState({
    this.devices = const [],
    this.activeModule,
    this.status = Requestenum.init,
    this.flow = DeviceFlow.idle,
    this.errorMessage,
    this.loadingIds = const {},
    this.automationLimit = 100,
  });

  DeviceState copyWith({
    List<DeviceModule>? devices,
    DeviceModule? activeModule,
    Requestenum? status,
    DeviceFlow? flow,
    String? errorMessage,
    Set<int>? loadingIds,
    int? automationLimit,
  }) {
    return DeviceState(
      devices: devices ?? this.devices,
      activeModule: activeModule ?? this.activeModule,
      status: status ?? this.status,
      flow: flow ?? this.flow,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingIds: loadingIds ?? this.loadingIds,
      automationLimit: automationLimit ?? this.automationLimit,
    );
  }
}