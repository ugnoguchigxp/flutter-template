import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:flutter_template/src/core/i18n/app_localizations.dart';

import '../../data/models/dashboard_models.dart';

class PipelineTable extends StatelessWidget {
  const PipelineTable({super.key, required this.stages});

  final List<PipelineStage> stages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DataTable2(
      columnSpacing: 16,
      horizontalMargin: 12,
      minWidth: 400,
      columns: [
        DataColumn2(
          label: Text(context.tr('dashboard.pipeline_table.stage')),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text(context.tr('dashboard.pipeline_table.leads')),
          numeric: true,
        ),
        DataColumn2(
          label: Text(context.tr('dashboard.pipeline_table.conversion')),
          numeric: true,
        ),
      ],
      rows: [
        for (final stage in stages)
          DataRow2.byIndex(
            index: stages.indexOf(stage),
            cells: [
              DataCell(Text(_localizedPipelineStage(context, stage.stage))),
              DataCell(Text('${stage.leads}')),
              DataCell(
                Chip(
                  label: Text(
                    '${(stage.conversionRate * 100).toStringAsFixed(1)}%',
                  ),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

String _localizedPipelineStage(BuildContext context, String value) {
  final normalized = value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');

  if (normalized.isEmpty) {
    return value;
  }

  final dashboardKey = 'dashboard.pipeline_stages.$normalized';
  final dashboardTranslation = context.tr(dashboardKey);
  if (dashboardTranslation != dashboardKey) {
    return dashboardTranslation;
  }

  final demoKey = 'ui_demo.pipeline_stages.$normalized';
  final demoTranslation = context.tr(demoKey);
  if (demoTranslation != demoKey) {
    return demoTranslation;
  }

  return value;
}
