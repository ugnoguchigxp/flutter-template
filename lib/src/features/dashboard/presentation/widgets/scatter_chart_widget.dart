import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:flutter_template/src/core/i18n/app_localizations.dart';

class ScatterChartWidget extends StatelessWidget {
  const ScatterChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final groups = [
      context.tr('dashboard.segments.a'),
      context.tr('dashboard.segments.b'),
      context.tr('dashboard.segments.c'),
      context.tr('dashboard.segments.d'),
    ];

    final data = [
      {'x': 1, 'y': 2, 'size': 6, 'group': groups[0]},
      {'x': 2, 'y': 3.5, 'size': 8, 'group': groups[0]},
      {'x': 3, 'y': 2.8, 'size': 7, 'group': groups[1]},
      {'x': 4, 'y': 4.2, 'size': 9, 'group': groups[1]},
      {'x': 5, 'y': 3.1, 'size': 5, 'group': groups[2]},
      {'x': 6, 'y': 5.0, 'size': 10, 'group': groups[2]},
      {'x': 7, 'y': 4.5, 'size': 7, 'group': groups[3]},
      {'x': 8, 'y': 3.9, 'size': 6, 'group': groups[0]},
      {'x': 9, 'y': 4.8, 'size': 8, 'group': groups[1]},
      {'x': 10, 'y': 5.5, 'size': 9, 'group': groups[2]},
    ];

    return SizedBox(
      height: 300,
      child: Chart(
        data: data,
        variables: {
          'x': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['x'] as num,
          ),
          'y': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['y'] as num,
          ),
          'size': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['size'] as num,
          ),
          'group': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['group'] as String,
          ),
        },
        marks: [
          PointMark(
            size: SizeEncode(variable: 'size', values: [5, 20]),
            color: ColorEncode(
              variable: 'group',
              values: [
                colorScheme.primary,
                colorScheme.secondary,
                colorScheme.tertiary,
                colorScheme.error,
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
