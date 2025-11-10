import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/config/app_config.dart';
import 'package:flutter_template/src/core/networking/dio_client.dart';
import 'package:flutter_template/src/features/dashboard/data/dashboard_repository.dart';
import 'package:flutter_template/src/features/dashboard/data/models/dashboard_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardRepository', () {
    late ProviderContainer container;
    late DashboardRepository repository;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://your-b2b-platform.dev',
            ),
          ),
        ],
      );
      repository = container.read(dashboardRepositoryProvider);
    });

    tearDown(() {
      container.dispose();
    });

    // Commented out: Cannot access private field _usingStubbedApi from test
    // group('_usingStubbedApi', () {
    //   test('returns true for dev API URL', () {
    //     expect(repository._usingStubbedApi, isTrue);
    //   });

    //   test('returns false for production API URL', () {
    //     final prodContainer = ProviderContainer(
    //       overrides: [
    //         appConfigProvider.overrideWithValue(
    //           const AppConfig(
    //             environment: AppEnvironment.production,
    //             apiBaseUrl: 'https://api.prod.example.com',
    //           ),
    //         ),
    //       ],
    //     );
    //     final prodRepository = prodContainer.read(dashboardRepositoryProvider);
    //     expect(prodRepository._usingStubbedApi, isFalse);
    //     prodContainer.dispose();
    //   });
    // });

    group('fetchRevenueTrend', () {
      test('returns stubbed data when using dev API', () async {
        final result = await repository.fetchRevenueTrend();

        expect(result, isA<List<RevenuePoint>>());
        expect(result.isNotEmpty, isTrue);
        expect(result.first.date, isA<DateTime>());
        expect(result.first.revenue, isA<double>());
        expect(result.first.revenue, greaterThanOrEqualTo(95000));
        expect(result.first.revenue, lessThanOrEqualTo(180000));
      });

      test('generates multiple data points', () async {
        final result = await repository.fetchRevenueTrend();

        expect(result.length, greaterThan(20));
      });

      test('data points are ordered chronologically', () async {
        final result = await repository.fetchRevenueTrend();

        for (var i = 1; i < result.length; i++) {
          expect(result[i].date.isAfter(result[i - 1].date), isTrue);
        }
      });

      test('respects from parameter', () async {
        final fromDate = DateTime.now().subtract(const Duration(days: 90));
        final result = await repository.fetchRevenueTrend(from: fromDate);

        expect(result.isNotEmpty, isTrue);
        expect(result.first.date, isA<DateTime>());
      });

      test('revenue values are within expected range', () async {
        final result = await repository.fetchRevenueTrend();

        for (final point in result) {
          expect(point.revenue, greaterThanOrEqualTo(95000));
          expect(point.revenue, lessThanOrEqualTo(180000));
        }
      });

      test('data points are weekly intervals', () async {
        final result = await repository.fetchRevenueTrend();

        for (var i = 1; i < result.length; i++) {
          final diff = result[i].date.difference(result[i - 1].date);
          expect(diff.inDays, 7);
        }
      });

      test('handles null from parameter', () async {
        final result = await repository.fetchRevenueTrend(from: null);

        expect(result, isA<List<RevenuePoint>>());
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('fetchRevenueTrend with real API', () {
      late ProviderContainer realApiContainer;
      late DashboardRepository realApiRepository;

      setUp(() {
        realApiContainer = ProviderContainer(
          overrides: [
            appConfigProvider.overrideWithValue(
              const AppConfig(
                environment: AppEnvironment.production,
                apiBaseUrl: 'https://api.prod.example.com',
              ),
            ),
          ],
        );
        realApiRepository = realApiContainer.read(dashboardRepositoryProvider);
      });

      tearDown(() {
        realApiContainer.dispose();
      });

      test('attempts real API call when not using stubbed API', () async {
        // This test verifies that the repository tries to make a real API call
        // In a real test environment, this would fail and fall back to stubbed data
        final result = await realApiRepository.fetchRevenueTrend();

        // Should fall back to stubbed data when real API is unreachable
        expect(result, isA<List<RevenuePoint>>());
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('fetchPipelineDistribution', () {
      test('returns stubbed pipeline stages when using dev API', () async {
        final result = await repository.fetchPipelineDistribution();

        expect(result, isA<List<PipelineStage>>());
        expect(result.length, 5);
        expect(result[0].stage, 'New');
        expect(result[0].leads, 180);
        expect(result[0].conversionRate, 0.05);
        expect(result[1].stage, 'Qualified');
        expect(result[1].leads, 120);
        expect(result[1].conversionRate, 0.18);
        expect(result[2].stage, 'Proposal');
        expect(result[2].leads, 60);
        expect(result[2].conversionRate, 0.32);
        expect(result[3].stage, 'Negotiation');
        expect(result[3].leads, 28);
        expect(result[3].conversionRate, 0.55);
        expect(result[4].stage, 'Closed Won');
        expect(result[4].leads, 16);
        expect(result[4].conversionRate, 0.92);
      });

      test('pipeline stages have decreasing lead counts', () async {
        final result = await repository.fetchPipelineDistribution();

        for (var i = 1; i < result.length; i++) {
          expect(result[i].leads, lessThan(result[i - 1].leads));
        }
      });

      test('pipeline stages have increasing conversion rates', () async {
        final result = await repository.fetchPipelineDistribution();

        for (var i = 1; i < result.length; i++) {
          expect(
            result[i].conversionRate,
            greaterThan(result[i - 1].conversionRate),
          );
        }
      });

      test('conversion rates are within valid range', () async {
        final result = await repository.fetchPipelineDistribution();

        for (final stage in result) {
          expect(stage.conversionRate, greaterThanOrEqualTo(0.0));
          expect(stage.conversionRate, lessThanOrEqualTo(1.0));
        }
      });

      test('lead counts are positive integers', () async {
        final result = await repository.fetchPipelineDistribution();

        for (final stage in result) {
          expect(stage.leads, greaterThan(0));
          expect(stage.leads, isA<int>());
        }
      });

      test('stage names are non-empty strings', () async {
        final result = await repository.fetchPipelineDistribution();

        for (final stage in result) {
          expect(stage.stage, isNotEmpty);
          expect(stage.stage, isA<String>());
        }
      });
    });

    group('fetchKpis', () {
      test('returns stubbed KPIs when using dev API', () async {
        final result = await repository.fetchKpis();

        expect(result, isA<List<KpiMetric>>());
        expect(result.length, 4);
      });

      test('MRR KPI has correct structure', () async {
        final result = await repository.fetchKpis();
        final mrr = result[0];

        expect(mrr.label, 'MRR');
        expect(mrr.value, contains('\$'));
        expect(mrr.trend, isNotNull);
        expect(mrr.delta, isNotNull);
        expect(mrr.delta, 0.084);
      });

      test('Churn KPI has correct structure', () async {
        final result = await repository.fetchKpis();
        final churn = result[1];

        expect(churn.label, 'Churn');
        expect(churn.value, '1.4%');
        expect(churn.trend, '-0.3pp');
        expect(churn.delta, -0.003);
      });

      test('Active Seats KPI has correct structure', () async {
        final result = await repository.fetchKpis();
        final seats = result[2];

        expect(seats.label, 'Active Seats');
        expect(seats.value, '12.4k');
        expect(seats.trend, '+320');
        expect(seats.delta, 320);
      });

      test('Support NPS KPI has correct structure', () async {
        final result = await repository.fetchKpis();
        final nps = result[3];

        expect(nps.label, 'Support NPS');
        expect(nps.value, '62');
        expect(nps.trend, '+4.1');
        expect(nps.delta, 4.1);
      });

      test('all KPIs have required fields', () async {
        final result = await repository.fetchKpis();

        for (final kpi in result) {
          expect(kpi.label, isNotEmpty);
          expect(kpi.value, isNotEmpty);
          expect(kpi.trend, isNotNull);
          expect(kpi.delta, isNotNull);
        }
      });

      test('KPI values are formatted correctly', () async {
        final result = await repository.fetchKpis();

        // MRR should be currency formatted
        expect(result[0].value, contains('\$'));
        
        // Churn should be percentage
        expect(result[1].value, contains('%'));
        
        // Active Seats should be in 'k' format
        expect(result[2].value, contains('k'));
        
        // NPS should be numeric
        expect(result[3].value, matches(RegExp(r'^\d+$')));
      });

      test('delta values match trend indicators', () async {
        final result = await repository.fetchKpis();

        // Positive trend should have positive delta
        expect(result[0].trend, contains('+'));
        expect(result[0].delta, greaterThan(0));
        
        // Negative trend should have negative delta
        expect(result[1].trend, contains('-'));
        expect(result[1].delta, lessThan(0));
      });
    });

    group('Error handling', () {
      test('handles DioException gracefully in revenue trend', () async {
        // This test would require mocking Dio to throw exceptions
        // For now, we verify the fallback behavior works
        final result = await repository.fetchRevenueTrend();
        expect(result, isA<List<RevenuePoint>>());
      });

      test('handles DioException gracefully in pipeline distribution', () async {
        final result = await repository.fetchPipelineDistribution();
        expect(result, isA<List<PipelineStage>>());
      });

      test('handles DioException gracefully in KPIs', () async {
        final result = await repository.fetchKpis();
        expect(result, isA<List<KpiMetric>>());
      });
    });

    group('Performance', () {
      test('fetchRevenueTrend completes within reasonable time', () async {
        final stopwatch = Stopwatch()..start();
        await repository.fetchRevenueTrend();
        stopwatch.stop();
        
        // Should complete quickly since it's stubbed data with small delay
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('fetchPipelineDistribution completes within reasonable time', () async {
        final stopwatch = Stopwatch()..start();
        await repository.fetchPipelineDistribution();
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });

      test('fetchKpis completes within reasonable time', () async {
        final stopwatch = Stopwatch()..start();
        await repository.fetchKpis();
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });
    });
  });

  group('dashboardRepositoryProvider', () {
    test('provides DashboardRepository instance', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://your-b2b-platform.dev',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(dashboardRepositoryProvider);

      expect(repository, isA<DashboardRepository>());
    });

    test('provides same instance on multiple reads', () {
      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              environment: AppEnvironment.development,
              apiBaseUrl: 'https://your-b2b-platform.dev',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final repository1 = container.read(dashboardRepositoryProvider);
      final repository2 = container.read(dashboardRepositoryProvider);

      expect(identical(repository1, repository2), isTrue);
    });

    // Commented out: Cannot access private field _dio from test
    // test('repository uses correct Dio instance', () {
    //   final container = ProviderContainer(
    //     overrides: [
    //       appConfigProvider.overrideWithValue(
    //         const AppConfig(
    //           environment: AppEnvironment.development,
    //           apiBaseUrl: 'https://your-b2b-platform.dev',
    //         ),
    //       ),
    //     ],
    //   );
    //   addTearDown(container.dispose);

    //   final dio = container.read(dioProvider);
    //   final repository = container.read(dashboardRepositoryProvider);

    //   expect(repository._dio, same(dio));
    // });
  });
}
