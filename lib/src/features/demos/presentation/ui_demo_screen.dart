import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:flutter_template/src/core/i18n/app_localizations.dart';

import '../../../core/i18n/locale_provider.dart';
import '../../dashboard/data/models/dashboard_models.dart';
import '../../dashboard/presentation/widgets/pipeline_table.dart';
import 'barcode_scanner_screen.dart';
import 'widgets/map_widget.dart';

class UiDemoScreen extends HookConsumerWidget {
  const UiDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final form = useMemoized(
      () => FormGroup({
        'company': FormControl<String>(
          value: context.tr('ui_demo.form.default_company'),
          validators: [Validators.required],
        ),
        'email': FormControl<String>(
          value: context.tr('ui_demo.form.default_email'),
          validators: [Validators.required, Validators.email],
        ),
        'seats': FormControl<int>(
          value: 25,
          validators: [Validators.required, Validators.number],
        ),
        'renewal': FormControl<DateTime>(
          value: DateTime.now().add(const Duration(days: 120)),
        ),
      }),
      [locale],
    );

    useEffect(() => form.dispose, [form]);

    final pipelineStages = useMemoized(_buildPipelineStages, const []);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('ui_demo.title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open Full Width Modal',
            onPressed: () => _showFullWidthModal(context),
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref, currentLocale),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          Text(
            context.tr('ui_demo.title'),
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('ui_demo.subtitle'),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: context.tr('ui_demo.sections.data_table.title'),
            subtitle: context.tr('ui_demo.sections.data_table.subtitle'),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: PipelineTable(stages: pipelineStages),
            ),
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: context.tr('ui_demo.sections.reactive_forms.title'),
            subtitle: context.tr('ui_demo.sections.reactive_forms.subtitle'),
            child: ReactiveForm(
              formGroup: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _ReactiveTextField(
                        controlName: 'company',
                        label: context.tr('ui_demo.form.company_label'),
                      ),
                      _ReactiveTextField(
                        controlName: 'email',
                        label: context.tr('ui_demo.form.email_label'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _SeatField(),
                      _RenewalPicker(controlName: 'renewal'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ReactiveFormConsumer(
                    builder: (context, formGroup, child) => FilledButton.icon(
                      icon: const Icon(Icons.visibility),
                      label: Text(context.tr('ui_demo.form.preview')),
                      onPressed: formGroup.valid
                          ? () async {
                              final values = formGroup.value;
                              await showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    context.tr('ui_demo.form.payload_title'),
                                  ),
                                  content: Text(values.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(context.tr('common.close')),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Maps',
            subtitle:
                'Platform-specific maps (Apple Maps on iOS, Google Maps on Android)',
            child: const MapWidget(),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('account.title'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(context.tr('account.language')),
            subtitle: Text(_languageLabel(context, currentLocale.languageCode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              _showLanguageDialog(context, ref);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.tr('account.settings')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('Barcode Scanner'),
            subtitle: const Text('Scan QR codes and barcodes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              unawaited(
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const BarcodeScannerScreen(),
                  ),
                ),
              );
            },
          ),
          const Divider(height: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              context.tr('account.logout'),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);

    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.tr('settings.select_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(context.tr('languages.japanese')),
                value: 'ja',
                groupValue: currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(localeProvider.notifier).setLocale(Locale(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<String>(
                title: Text(context.tr('languages.english')),
                value: 'en',
                groupValue: currentLocale.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(localeProvider.notifier).setLocale(Locale(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.tr('common.close')),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.tr('account.logout')),
          content: Text(context.tr('account.logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.tr('common.cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.tr('account.logout'))),
                );
              },
              child: Text(
                context.tr('common.ok'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullWidthModal(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                AppBar(
                  title: const Text('Full Width Modal'),
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        'Full Width Modal',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This modal has no horizontal padding and takes up the full width of the screen.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(
                        10,
                        (index) => Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text('Item ${index + 1}'),
                            subtitle: const Text(
                              'This is a sample item in the full width modal',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _languageLabel(BuildContext context, String languageCode) {
  switch (languageCode) {
    case 'ja':
      return context.tr('languages.japanese');
    case 'en':
      return context.tr('languages.english');
    default:
      return languageCode;
  }
}

List<PipelineStage> _buildPipelineStages() {
  return const [
    PipelineStage(stage: 'Discovery', leads: 42, conversionRate: 0.18),
    PipelineStage(stage: 'Evaluation', leads: 28, conversionRate: 0.31),
    PipelineStage(stage: 'Legal', leads: 12, conversionRate: 0.44),
    PipelineStage(stage: 'Closed Won', leads: 8, conversionRate: 0.72),
  ];
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _ReactiveTextField extends StatelessWidget {
  const _ReactiveTextField({
    required this.controlName,
    required this.label,
    this.keyboardType,
  });

  final String controlName;
  final String label;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ReactiveTextField<String>(
        formControlName: controlName,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validationMessages: {
          ValidationMessage.required: (_) => context.tr('validation.required'),
          ValidationMessage.email: (_) => context.tr('validation.email'),
        },
      ),
    );
  }
}

class _SeatField extends StatelessWidget {
  const _SeatField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ReactiveTextField<int>(
        formControlName: 'seats',
        keyboardType: TextInputType.number,
        valueAccessor: IntValueAccessor(),
        decoration: InputDecoration(
          labelText: context.tr('ui_demo.form.seats_label'),
        ),
        validationMessages: {
          ValidationMessage.required: (_) => context.tr('validation.required'),
        },
      ),
    );
  }
}

class _RenewalPicker extends StatelessWidget {
  const _RenewalPicker({required this.controlName});

  final String controlName;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatter = DateFormat.yMMMd(locale);
    return SizedBox(
      width: 220,
      child: ReactiveDatePicker<DateTime>(
        formControlName: controlName,
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 720)),
        builder: (context, picker, child) => InkWell(
          onTap: picker.showPicker,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: context.tr('ui_demo.form.renewal_label'),
            ),
            child: Text(
              picker.value != null
                  ? formatter.format(picker.value!)
                  : context.tr('ui_demo.form.select_date'),
            ),
          ),
        ),
      ),
    );
  }
}
