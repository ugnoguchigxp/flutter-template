import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class FunnelChartWidget extends StatelessWidget {
  const FunnelChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 300,
      child: Chart(
        data: const [
          {'stage': 'Leads', 'value': 1000, 'index': 0},
          {'stage': 'Qualified', 'value': 750, 'index': 1},
          {'stage': 'Proposal', 'value': 500, 'index': 2},
          {'stage': 'Negotiation', 'value': 250, 'index': 3},
          {'stage': 'Closed', 'value': 150, 'index': 4},
        ],
        variables: {
          'stage': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['stage'] as String,
          ),
          'value': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['value'] as num,
          ),
          'index': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['index'] as num,
          ),
        },
        transforms: [Proportion(variable: 'value', as: 'percent')],
        marks: [
          IntervalMark(
            color: ColorEncode(
              variable: 'stage',
              values: [
                colorScheme.primary,
                colorScheme.primaryContainer,
                colorScheme.secondary,
                colorScheme.secondaryContainer,
                colorScheme.tertiary,
              ],
            ),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}
