class PaginationPatch<T> {
  final int offset;
  final int total;
  final String? errorMessage;
  final List<T> newData;

  PaginationPatch({
    required this.offset,
    required this.total,
    required this.newData,
    this.errorMessage,
  });
}
