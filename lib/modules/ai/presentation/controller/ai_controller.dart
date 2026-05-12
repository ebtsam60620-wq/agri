import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/ai/data/model/ai_analysis_model.dart';
import 'package:agri/modules/ai/domain/repository/ai_repository.dart';
import 'package:agri/modules/ai/presentation/controller/ai_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AiController extends AutoDisposeNotifier<AiState> {
  AiController(this._repository);

  final AiRepository _repository;

  @override
  AiState build() => AiState();

  Future<void> fetchAnalyses({int page = 1, int perPage = 20}) async {
    if (state.status == Requestenum.loading) return;
    
    if (page == 1) {
      state = state.copyWith(status: Requestenum.loading);
    } else {
      state = state.copyWith(isFetchingMore: true);
    }
    
    final result = await _repository.getAnalyses(page: page, perPage: perPage);

    result.fold(
      (failure) => state = state.copyWith(
        status: Requestenum.error,
        errorMessage: failure.message,
        isFetchingMore: false,
      ),
      (data) {
        final List items = (data['items'] ?? []) as List;
        final analysesList = items.map((e) => AiAnalysisModel.fromJson(e as Map<String, dynamic>)).toList();
        
        List<AiAnalysisModel> currentAnalyses = page == 1 ? [] : state.analyses;
        
        state = state.copyWith(
          status: Requestenum.success,
          analyses: [...currentAnalyses, ...analysesList],
          total: data['total'] ?? 0,
          pages: data['pages'] ?? 0,
          currentPage: data['current_page'] ?? page,
          isFetchingMore: false,
        );
      },
    );
  }

  Future<void> fetchMoreAnalyses() async {
    if (state.isFetchingMore || state.status == Requestenum.loading || state.hasReachedMax) return;
    
    await fetchAnalyses(page: state.currentPage + 1);
  }
}
