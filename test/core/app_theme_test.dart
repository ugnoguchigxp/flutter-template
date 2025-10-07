import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/src/app/theme/app_theme.dart';

void main() {
  test('AppThemeBundle provides light and dark themes', () {
    final bundle = AppThemeBundle(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
    );
    // Ensure fields are accessible
    expect(bundle.light.brightness, Brightness.light);
    expect(bundle.dark.brightness, Brightness.dark);
  });
}
