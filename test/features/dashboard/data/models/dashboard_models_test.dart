import 'package:flutter_template/src/features/dashboard/data/models/dashboard_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RevenuePoint', () {
    test('creates instance with required fields', () {
      final date = DateTime(2024, 1, 1);
      final revenuePoint = RevenuePoint(date: date, revenue: 100000.0);

      expect(revenuePoint.date, date);
      expect(revenuePoint.revenue, 100000.0);
    });

    test('fromJson creates valid RevenuePoint', () {
      final json = {
        'date': '2024-01-01T00:00:00.000',
        'revenue': 150000.5,
      };

      final revenuePoint = RevenuePoint.fromJson(json);

      expect(revenuePoint.date, DateTime.parse('2024-01-01T00:00:00.000'));
      expect(revenuePoint.revenue, 150000.5);
    });

    test('toJson creates valid JSON', () {
      final date = DateTime(2024, 1, 1);
      final revenuePoint = RevenuePoint(date: date, revenue: 100000.0);

      final json = revenuePoint.toJson();

      expect(json['date'], date.toIso8601String());
      expect(json['revenue'], 100000.0);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = RevenuePoint(
        date: DateTime(2024, 1, 1),
        revenue: 100000.0,
      );

      final updated = original.copyWith(revenue: 200000.0);

      expect(updated.date, original.date);
      expect(updated.revenue, 200000.0);
    });

    test('equality works correctly', () {
      final date = DateTime(2024, 1, 1);
      final point1 = RevenuePoint(date: date, revenue: 100000.0);
      final point2 = RevenuePoint(date: date, revenue: 100000.0);
      final point3 = point1.copyWith(revenue: 200000.0);

      expect(point1, point2);
      expect(point1, isNot(point3));
      expect(point1.hashCode, point2.hashCode);
    });
  });

  group('PipelineStage', () {
    test('creates instance with required fields', () {
      const stage = PipelineStage(
        stage: 'Qualified',
        leads: 120,
        conversionRate: 0.18,
      );

      expect(stage.stage, 'Qualified');
      expect(stage.leads, 120);
      expect(stage.conversionRate, 0.18);
    });

    test('fromJson creates valid PipelineStage', () {
      final json = {
        'stage': 'Proposal',
        'leads': 60,
        'conversionRate': 0.32,
      };

      final stage = PipelineStage.fromJson(json);

      expect(stage.stage, 'Proposal');
      expect(stage.leads, 60);
      expect(stage.conversionRate, 0.32);
    });

    test('toJson creates valid JSON', () {
      const stage = PipelineStage(
        stage: 'Negotiation',
        leads: 28,
        conversionRate: 0.55,
      );

      final json = stage.toJson();

      expect(json['stage'], 'Negotiation');
      expect(json['leads'], 28);
      expect(json['conversionRate'], 0.55);
    });

    test('copyWith creates new instance with updated fields', () {
      const original = PipelineStage(
        stage: 'New',
        leads: 180,
        conversionRate: 0.05,
      );

      final updated = original.copyWith(leads: 200);

      expect(updated.stage, original.stage);
      expect(updated.leads, 200);
      expect(updated.conversionRate, original.conversionRate);
    });

    test('equality works correctly', () {
      const stage1 = PipelineStage(
        stage: 'New',
        leads: 180,
        conversionRate: 0.05,
      );
      const stage2 = PipelineStage(
        stage: 'New',
        leads: 180,
        conversionRate: 0.05,
      );
      final stage3 = stage1.copyWith(leads: 200);

      expect(stage1, stage2);
      expect(stage1, isNot(stage3));
      expect(stage1.hashCode, stage2.hashCode);
    });
  });

  group('KpiMetric', () {
    test('creates instance with required fields', () {
      const kpi = KpiMetric(
        label: 'MRR',
        value: '\$132k',
      );

      expect(kpi.label, 'MRR');
      expect(kpi.value, '\$132k');
      expect(kpi.trend, isNull);
      expect(kpi.delta, isNull);
    });

    test('creates instance with optional fields', () {
      const kpi = KpiMetric(
        label: 'MRR',
        value: '\$132k',
        trend: '+8.4% MoM',
        delta: 0.084,
      );

      expect(kpi.label, 'MRR');
      expect(kpi.value, '\$132k');
      expect(kpi.trend, '+8.4% MoM');
      expect(kpi.delta, 0.084);
    });

    test('fromJson creates valid KpiMetric', () {
      final json = {
        'label': 'Churn',
        'value': '1.4%',
        'trend': '-0.3pp',
        'delta': -0.003,
      };

      final kpi = KpiMetric.fromJson(json);

      expect(kpi.label, 'Churn');
      expect(kpi.value, '1.4%');
      expect(kpi.trend, '-0.3pp');
      expect(kpi.delta, -0.003);
    });

    test('toJson creates valid JSON', () {
      const kpi = KpiMetric(
        label: 'Active Seats',
        value: '12.4k',
        trend: '+320',
        delta: 320.0,
      );

      final json = kpi.toJson();

      expect(json['label'], 'Active Seats');
      expect(json['value'], '12.4k');
      expect(json['trend'], '+320');
      expect(json['delta'], 320.0);
    });

    test('copyWith creates new instance with updated fields', () {
      const original = KpiMetric(
        label: 'Support NPS',
        value: '62',
        trend: '+4.1',
        delta: 4.1,
      );

      final updated = original.copyWith(value: '65', delta: 5.0);

      expect(updated.label, original.label);
      expect(updated.value, '65');
      expect(updated.trend, original.trend);
      expect(updated.delta, 5.0);
    });

    test('equality works correctly', () {
      const kpi1 = KpiMetric(label: 'MRR', value: '\$132k');
      const kpi2 = KpiMetric(label: 'MRR', value: '\$132k');
      final kpi3 = kpi1.copyWith(value: '\$140k');

      expect(kpi1, kpi2);
      expect(kpi1, isNot(kpi3));
      expect(kpi1.hashCode, kpi2.hashCode);
    });

    test('handles null optional fields in JSON', () {
      final json = {
        'label': 'Test',
        'value': '100',
      };

      final kpi = KpiMetric.fromJson(json);

      expect(kpi.label, 'Test');
      expect(kpi.value, '100');
      expect(kpi.trend, isNull);
      expect(kpi.delta, isNull);
    });
  });
}
