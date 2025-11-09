import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class AreaChartWidget extends StatelessWidget {
  const AreaChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 300,
      child: Chart(
        data: const [
          {'month': 'Jan', 'value': 45},
          {'month': 'Feb', 'value': 52},
          {'month': 'Mar', 'value': 48},
          {'month': 'Apr', 'value': 61},
          {'month': 'May', 'value': 55},
          {'month': 'Jun', 'value': 67},
        ],
        variables: {
          'month': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['month'] as String,
          ),
          'value': Variable(
            accessor: (Map<dynamic, dynamic> map) => map['value'] as num,
          ),
        },
        marks: [
          AreaMark(
            shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
            color: ColorEncode(
              value: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          LineMark(
            shape: ShapeEncode(value: BasicLineShape(smooth: true)),
            size: SizeEncode(value: 2),
            color: ColorEncode(value: colorScheme.primary),
          ),
        ],
        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
      ),
    );
  }
}
