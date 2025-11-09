import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

import '../../data/models/dashboard_models.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({super.key, required this.series});

  final List<RevenuePoint> series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.MMMd(locale);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Chart(
        data: [
          for (var i = 0; i < series.length; i++)
            {
              'index': i,
              'revenue': series[i].revenue,
              'date': dateFormat.format(series[i].date),
            },
        ],
        variables: {
          'index': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['index'] as num,
          ),
          'revenue': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['revenue'] as num,
          ),
          'date': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['date'] as String,
          ),
        },
        marks: [
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 4),
            color: ColorEncode(value: color),
          ),
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(value: color.withValues(alpha: 0.12)),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}
