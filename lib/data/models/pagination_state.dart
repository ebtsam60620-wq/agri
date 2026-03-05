abstract class PaginationState<T> {
  final List<T> data;
  final PaginationStatus status;
  final int offset;
  final int limit;
  final int total;
  final String? errorMessage;

  const PaginationState({
    required this.data,
    required this.status,
    required this.offset,
    required this.limit,
    required this.total,
    this.errorMessage,
  });

  PaginationState copyWith({
    List<T>? data,
    PaginationStatus? status,
    int? offset,
    int? limit,
    int? total,
    String? errorMessage,
  });
  bool get isLoading =>
      status == PaginationStatus.loading ||
      status == PaginationStatus.reloading ||
      status == PaginationStatus.paginating;

  bool get isComplete =>
      status != PaginationStatus.initial && data.length == total;
}

enum PaginationStatus {
  initial,
  loading,
  reloading,
  paginating,
  loaded,
  error,
}

class PaginationStateImpl<T> extends PaginationState<T> {
  const PaginationStateImpl({
    required super.data,
    required super.status,
    required super.offset,
    required super.limit,
    required super.total,
    super.errorMessage,
  });

  factory PaginationStateImpl.initial({int limit = 10}) {
    return PaginationStateImpl<T>(
      data: [],
      status: PaginationStatus.initial,
      offset: 0,
      limit: limit,
      total: 0,
      errorMessage: null,
    );
  }

  @override
  PaginationStateImpl<T> copyWith({
    List<T>? data,
    PaginationStatus? status,
    int? offset,
    int? limit,
    int? total,
    String? errorMessage,
  }) {
    return PaginationStateImpl<T>(
      data: data ?? this.data,
      status: status ?? this.status,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  PaginationStateImpl.fromJson(
    Map<String, dynamic> json,
    String fromBackend,
    T Function(Map<String, dynamic>) fromJsonT,
  ) : super(
          data: (json[fromBackend] as List)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList(),
          status: PaginationStatus.loaded,
          offset: json['offset'] as int? ?? 0,
          limit: json['total'] as int? ?? 10,
          total: json['total'] as int? ?? 0,
          errorMessage: null,
        );
}
