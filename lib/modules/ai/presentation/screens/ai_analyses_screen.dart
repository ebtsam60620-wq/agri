import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/ai/data/model/ai_analysis_model.dart';
import 'package:agri/notifiers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AiAnalysesScreen extends ConsumerStatefulWidget {
  const AiAnalysesScreen({super.key});

  @override
  ConsumerState<AiAnalysesScreen> createState() => _AiAnalysesScreenState();
}

class _AiAnalysesScreenState extends ConsumerState<AiAnalysesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiProvider.notifier).fetchAnalyses();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(aiProvider.notifier).fetchMoreAnalyses();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(aiProvider.notifier).fetchAnalyses(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Analyses'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _buildBody(aiState)),
    );
  }

  Widget _buildBody(aiState) {
    if (aiState.status == Requestenum.loading && aiState.analyses.isEmpty) {
      return ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) => const _AiAnalysisSkeleton(),
      );
    }

    if (aiState.status == Requestenum.error && aiState.analyses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(aiState.errorMessage ?? 'An error occurred'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(aiProvider.notifier).fetchAnalyses(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (aiState.status == Requestenum.success && aiState.analyses.isEmpty) {
      return const Center(child: Text('No analyses found.'));
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: aiState.analyses.length + 1,
      itemBuilder: (context, index) {
        if (index == aiState.analyses.length) {
          return _buildBottomIndicator(aiState);
        }

        final analysis = aiState.analyses[index];
        return _AiAnalysisCard(analysis: analysis);
      },
    );
  }

  Widget _buildBottomIndicator(aiState) {
    if (aiState.isFetchingMore) {
      return Center(child: CircularProgressIndicator());
    } else if (aiState.status == Requestenum.error &&
        aiState.analyses.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Error loading more: ${aiState.errorMessage}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () =>
                    ref.read(aiProvider.notifier).fetchMoreAnalyses(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _AiAnalysisCard extends StatelessWidget {
  const _AiAnalysisCard({required this.analysis});

  final AiAnalysisModel analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = analysis.createdAt != null
        ? DateFormat.yMMMd().add_Hm().format(analysis.createdAt!)
        : 'Unknown Date';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (analysis.moduleNickname != null ||
                    analysis.moduleCode != null)
                  Chip(
                    label: Text(
                      analysis.moduleNickname ?? analysis.moduleCode!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: theme.colorScheme.primaryContainer,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (analysis.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: analysis.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Disease Detection',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            analysis.disease.detected
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_outline,
                            color: analysis.disease.detected
                                ? Colors.red
                                : Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              analysis.disease.detected
                                  ? (analysis.disease.name ??
                                        'Disease Detected')
                                  : 'Healthy',
                              style: TextStyle(
                                color: analysis.disease.detected
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (analysis.disease.confidence != null)
                        Text(
                          'Confidence: ${(analysis.disease.confidence! * 100).toStringAsFixed(1)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      if (analysis.disease.treatment != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          analysis.disease.treatment!,
                          style: theme.textTheme.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Harvest Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            analysis.harvest.status == 'ready'
                                ? Icons.eco
                                : Icons.eco_outlined,
                            color: analysis.harvest.status == 'ready'
                                ? Colors.green
                                : Colors.orange,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              analysis.harvest.status
                                      ?.replaceAll('_', ' ')
                                      .toUpperCase() ??
                                  'N/A',
                              style: TextStyle(
                                color: analysis.harvest.status == 'ready'
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (analysis.harvest.confidence != null)
                        Text(
                          'Confidence: ${(analysis.harvest.confidence! * 100).toStringAsFixed(1)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AiAnalysisSkeleton extends StatelessWidget {
  const _AiAnalysisSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 14,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 14,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 16,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 70,
                        height: 14,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
