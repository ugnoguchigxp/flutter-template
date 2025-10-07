import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_repository.dart';
import 'models/dashboard_models.dart';

final revenueTrendProvider = FutureProvider<List<RevenuePoint>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.fetchRevenueTrend();
});

final pipelineStagesProvider = FutureProvider<List<PipelineStage>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.fetchPipelineDistribution();
});

final dashboardKpisProvider = FutureProvider<List<KpiMetric>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.fetchKpis();
});
