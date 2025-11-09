import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class HeatmapChartWidget extends StatelessWidget {
  const HeatmapChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 300,
      child: Chart(
        data: const [
          {'hour': '9AM', 'Mon': 3, 'Tue': 4, 'Wed': 5, 'Thu': 6, 'Fri': 4},
          {'hour': '12PM', 'Mon': 7, 'Tue': 8, 'Wed': 9, 'Thu': 10, 'Fri': 7},
          {'hour': '3PM', 'Mon': 5, 'Tue': 6, 'Wed': 7, 'Thu': 8, 'Fri': 5},
        ],
        variables: {
          'hour': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['hour'] as String,
          ),
          'Mon': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['Mon'] as num,
          ),
          'Tue': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['Tue'] as num,
          ),
          'Wed': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['Wed'] as num,
          ),
          'Thu': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['Thu'] as num,
          ),
          'Fri': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['Fri'] as num,
          ),
        },
        marks: [
          LineMark(
            position: Varset('hour') * Varset('Mon'),
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 2),
            color: ColorEncode(value: colorScheme.primary),
          ),
          LineMark(
            position: Varset('hour') * Varset('Tue'),
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 2),
            color: ColorEncode(value: colorScheme.secondary),
          ),
          LineMark(
            position: Varset('hour') * Varset('Wed'),
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 2),
            color: ColorEncode(value: colorScheme.tertiary),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}
