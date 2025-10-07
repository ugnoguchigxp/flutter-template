import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const data = [
      {'segment': 'Enterprise', 'value': 35},
      {'segment': 'SMB', 'value': 25},
      {'segment': 'Startup', 'value': 22},
      {'segment': 'Other', 'value': 18},
    ];

    return SizedBox(
      height: 300,
      child: Chart(
        data: data,
        variables: {
          'segment': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['segment'] as String,
          ),
          'value': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['value'] as num,
          ),
        },
        transforms: [
          Proportion(
            variable: 'value',
            as: 'percent',
          ),
        ],
        marks: [
          IntervalMark(
            position: Varset('percent') / Varset('segment'),
            color: ColorEncode(
              variable: 'segment',
              values: [
                colorScheme.primary,
                colorScheme.secondary,
                colorScheme.tertiary,
                colorScheme.error,
              ],
            ),
            modifiers: [StackModifier()],
          ),
        ],
        coord: PolarCoord(transposed: true, dimCount: 1),
      ),
    );
  }
}
