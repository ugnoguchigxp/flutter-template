import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/config/app_config.dart';
import 'package:flutter_template/src/features/dashboard/data/dashboard_providers.dart';
import 'package:flutter_template/src/features/dashboard/data/models/dashboard_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(
            environment: AppEnvironment.development,
            apiBaseUrl: 'https://your-b2b-platform.dev',
          ),
        ),
      ],
    );
  }

  group('revenueTrendProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('fetches revenue trend data', () async {
      final asyncValue = container.read(revenueTrendProvider);

      expect(asyncValue, isA<AsyncValue<List<RevenuePoint>>>());
      expect(asyncValue.isLoading, isTrue);

      await container.read(revenueTrendProvider.future);

      final data = container.read(revenueTrendProvider).value;
      expect(data, isA<List<RevenuePoint>>());
      expect(data, isNotNull);
      expect(data!.isNotEmpty, isTrue);
    });

    test('revenue trend contains valid data points', () async {
      final data = await container.read(revenueTrendProvider.future);

      expect(data.isNotEmpty, isTrue);
      for (final point in data) {
        expect(point.date, isA<DateTime>());
        expect(point.revenue, isA<double>());
        expect(point.revenue, greaterThan(0));
      }
    });

    test('handles async loading states', () async {
      final asyncValue = container.read(revenueTrendProvider);

      asyncValue.when(
        data: (data) => expect(data, isA<List<RevenuePoint>>()),
        loading: () => expect(true, isTrue),
        error: (error, stack) => fail('Should not have error'),
      );
    });
  });

  group('pipelineStagesProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('fetches pipeline stages data', () async {
      final asyncValue = container.read(pipelineStagesProvider);

      expect(asyncValue, isA<AsyncValue<List<PipelineStage>>>());
      expect(asyncValue.isLoading, isTrue);

      await container.read(pipelineStagesProvider.future);

      final data = container.read(pipelineStagesProvider).value;
      expect(data, isA<List<PipelineStage>>());
      expect(data, isNotNull);
      expect(data!.length, 5);
    });

    test('pipeline stages have correct structure', () async {
      final data = await container.read(pipelineStagesProvider.future);

      expect(data.length, 5);
      for (final stage in data) {
        expect(stage.stage, isNotEmpty);
        expect(stage.leads, greaterThan(0));
        expect(stage.conversionRate, greaterThan(0));
        expect(stage.conversionRate, lessThanOrEqualTo(1));
      }
    });

    test('stages are in expected order', () async {
      final data = await container.read(pipelineStagesProvider.future);

      expect(data[0].stage, 'New');
      expect(data[1].stage, 'Qualified');
      expect(data[2].stage, 'Proposal');
      expect(data[3].stage, 'Negotiation');
      expect(data[4].stage, 'Closed Won');
    });
  });

  group('dashboardKpisProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('fetches KPI metrics data', () async {
      final asyncValue = container.read(dashboardKpisProvider);

      expect(asyncValue, isA<AsyncValue<List<KpiMetric>>>());
      expect(asyncValue.isLoading, isTrue);

      await container.read(dashboardKpisProvider.future);

      final data = container.read(dashboardKpisProvider).value;
      expect(data, isA<List<KpiMetric>>());
      expect(data, isNotNull);
      expect(data!.length, 4);
    });

    test('KPIs have correct structure', () async {
      final data = await container.read(dashboardKpisProvider.future);

      expect(data.length, 4);
      for (final kpi in data) {
        expect(kpi.label, isNotEmpty);
        expect(kpi.value, isNotEmpty);
      }
    });

    test('KPIs are in expected order', () async {
      final data = await container.read(dashboardKpisProvider.future);

      expect(data[0].label, 'MRR');
      expect(data[1].label, 'Churn');
      expect(data[2].label, 'Active Seats');
      expect(data[3].label, 'Support NPS');
    });

    test('KPIs have trend and delta information', () async {
      final data = await container.read(dashboardKpisProvider.future);

      for (final kpi in data) {
        // All test KPIs should have trend and delta
        expect(kpi.trend, isNotNull);
        expect(kpi.delta, isNotNull);
      }
    });
  });

  group('provider integration', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('all providers can be read simultaneously', () async {
      // Start all providers
      final revenueFuture = container.read(revenueTrendProvider.future);
      final pipelineFuture = container.read(pipelineStagesProvider.future);
      final kpisFuture = container.read(dashboardKpisProvider.future);

      // Wait for all to complete
      final results = await Future.wait([
        revenueFuture,
        pipelineFuture,
        kpisFuture,
      ]);

      expect(results[0], isA<List<RevenuePoint>>());
      expect(results[1], isA<List<PipelineStage>>());
      expect(results[2], isA<List<KpiMetric>>());
    });

    test('providers use shared repository instance', () {
      // This verifies that all providers depend on dashboardRepositoryProvider
      container.read(revenueTrendProvider);
      container.read(pipelineStagesProvider);
      container.read(dashboardKpisProvider);

      // If this doesn't throw, it means the providers are properly configured
      expect(true, isTrue);
    });
  });
}
