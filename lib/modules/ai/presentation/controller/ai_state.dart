import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/ai/data/model/ai_analysis_model.dart';

class AiState {
  final List<AiAnalysisModel> analyses;
  final int total;
  final int pages;
  final int currentPage;
  final Requestenum status;
  final String? errorMessage;
  final bool isFetchingMore;

  AiState({
    this.analyses = const [],
    this.total = 0,
    this.pages = 0,
    this.currentPage = 1,
    this.status = Requestenum.init,
    this.errorMessage,
    this.isFetchingMore = false,
  });

  bool get hasReachedMax => currentPage >= pages && pages != 0;

  AiState copyWith({
    List<AiAnalysisModel>? analyses,
    int? total,
    int? pages,
    int? currentPage,
    Requestenum? status,
    String? errorMessage,
    bool? isFetchingMore,
  }) {
    return AiState(
      analyses: analyses ?? this.analyses,
      total: total ?? this.total,
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
