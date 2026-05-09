part of 'crop_cycle_controller.dart';

class CropCycleState {
  final List<CropCycle> cropCycles;
  final Requestenum status;
  final String? errorMessage;
  final Requestenum addStatus;
  final Requestenum updateStatus;
  final Requestenum deleteStatus;

  CropCycleState({
    this.cropCycles = const [],
    this.status = Requestenum.init,
    this.errorMessage,
    this.addStatus = Requestenum.init,
    this.updateStatus = Requestenum.init,
    this.deleteStatus = Requestenum.init,
  });

  CropCycleState copyWith({
    List<CropCycle>? cropCycles,
    Requestenum? status,
    String? errorMessage,
    Requestenum? addStatus,
    Requestenum? updateStatus,
    Requestenum? deleteStatus,
  }) {
    return CropCycleState(
      cropCycles: cropCycles ?? this.cropCycles,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      addStatus: addStatus ?? this.addStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }
}
