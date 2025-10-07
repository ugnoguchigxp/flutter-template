import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/i18n/locale_provider.dart';
import '../../demos/presentation/barcode_scanner_screen.dart';

class AccountScreen extends HookConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      children: [
        Text(context.tr('account.title'), style: theme.textTheme.headlineMedium),
        const SizedBox(height: 32),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(context.tr('account.language')),
                subtitle: Text(
                  _languageLabel(context, currentLocale.languageCode),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showLanguageDialog(context, ref);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(context.tr('account.settings')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to settings screen
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Barcode Scanner'),
                subtitle: const Text('Scan QR codes and barcodes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  unawaited(Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const BarcodeScannerScreen(),
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              context.tr('account.logout'),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              _showLogoutDialog(context, ref);
            },
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);

    unawaited(showDialog<void>(
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
    ));
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    unawaited(showDialog<void>(
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
              // TODO: Implement logout logic
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
    ));
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
