import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/networking/dio_client.dart';
import 'models/dashboard_models.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepository(dio: dio);
});

class DashboardRepository {
  const DashboardRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  bool get _usingStubbedApi =>
      _dio.options.baseUrl.contains('your-b2b-platform.dev');

  Future<List<RevenuePoint>> fetchRevenueTrend({DateTime? from}) async {
    if (!_usingStubbedApi) {
      try {
        final response = await _dio.get<List<dynamic>>(
          '/analytics/revenue',
          queryParameters: {
            if (from != null) 'from': from.toIso8601String(),
          },
        );
        final payload = response.data;
        if (payload != null && payload.isNotEmpty) {
          return payload
              .map((entry) => RevenuePoint.fromJson(
                    Map<String, dynamic>.from(entry as Map),
                  ))
              .toList();
        }
      } on DioException catch (error, stackTrace) {
        debugPrint('Falling back to local revenue data: $error\n$stackTrace');
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 350));
    final now = DateTime.now();
    final seed = now.subtract(const Duration(days: 180));
    final rng = Random(seed.millisecondsSinceEpoch);
    final items = <RevenuePoint>[];

    DateTime cursor = seed;
    double baseline = 120000;
    while (cursor.isBefore(now)) {
      baseline += rng.nextDouble() * 4200 - 2100;
      items.add(
        RevenuePoint(
          date: cursor,
          revenue: baseline.clamp(95000, 180000),
        ),
      );
      cursor = cursor.add(const Duration(days: 7));
    }
    return items;
  }

  Future<List<PipelineStage>> fetchPipelineDistribution() async {
    if (!_usingStubbedApi) {
      try {
        final response = await _dio.get<List<dynamic>>('/analytics/pipeline');
        final payload = response.data;
        if (payload != null && payload.isNotEmpty) {
          return payload
              .map((entry) => PipelineStage.fromJson(
                    Map<String, dynamic>.from(entry as Map),
                  ))
              .toList();
        }
      } on DioException catch (error, stackTrace) {
        debugPrint('Using mock pipeline distribution: $error\n$stackTrace');
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const [
      PipelineStage(stage: 'New', leads: 180, conversionRate: 0.05),
      PipelineStage(stage: 'Qualified', leads: 120, conversionRate: 0.18),
      PipelineStage(stage: 'Proposal', leads: 60, conversionRate: 0.32),
      PipelineStage(stage: 'Negotiation', leads: 28, conversionRate: 0.55),
      PipelineStage(stage: 'Closed Won', leads: 16, conversionRate: 0.92),
    ];
  }

  Future<List<KpiMetric>> fetchKpis() async {
    if (!_usingStubbedApi) {
      try {
        final response = await _dio.get<List<dynamic>>('/analytics/kpis');
        final payload = response.data;
        if (payload != null && payload.isNotEmpty) {
          return payload
              .map((entry) => KpiMetric.fromJson(
                    Map<String, dynamic>.from(entry as Map),
                  ))
              .toList();
        }
      } on DioException catch (error, stackTrace) {
        debugPrint('Using offline KPI snapshot: $error\n$stackTrace');
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 160));
    final currency = NumberFormat.compactSimpleCurrency();
    return [
      KpiMetric(
        label: 'MRR',
        value: currency.format(132000),
        trend: '+8.4% MoM',
        delta: 0.084,
      ),
      KpiMetric(
        label: 'Churn',
        value: '1.4%',
        trend: '-0.3pp',
        delta: -0.003,
      ),
      KpiMetric(
        label: 'Active Seats',
        value: '12.4k',
        trend: '+320',
        delta: 320,
      ),
      KpiMetric(
        label: 'Support NPS',
        value: '62',
        trend: '+4.1',
        delta: 4.1,
      ),
    ];
  }
}
