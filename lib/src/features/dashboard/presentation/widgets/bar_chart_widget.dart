import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:flutter_template/src/core/i18n/app_localizations.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final quarters = [
      context.tr('dashboard.quarters.q1'),
      context.tr('dashboard.quarters.q2'),
      context.tr('dashboard.quarters.q3'),
      context.tr('dashboard.quarters.q4'),
    ];

    final data = [
      {'quarter': quarters[0], 'value': 68},
      {'quarter': quarters[1], 'value': 82},
      {'quarter': quarters[2], 'value': 75},
      {'quarter': quarters[3], 'value': 91},
    ];

    return SizedBox(
      height: 300,
      child: Chart(
        data: data,
        variables: {
          'quarter': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['quarter'] as String,
          ),
          'value': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['value'] as num,
          ),
        },
        marks: [
          IntervalMark(
            color: ColorEncode(
              variable: 'quarter',
              values: [
                colorScheme.primary,
                colorScheme.secondary,
                colorScheme.tertiary,
                colorScheme.primaryContainer,
              ],
            ),
          ),
        ],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
      ),
    );
  }
}
