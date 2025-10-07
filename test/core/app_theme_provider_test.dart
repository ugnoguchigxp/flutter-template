import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/app/theme/app_theme.dart';

void main() {
  test('appThemeProvider returns AppThemeBundle', () {
    final container = ProviderContainer();
    final bundle = container.read(appThemeProvider);
    expect(bundle.light, isNotNull);
    expect(bundle.dark, isNotNull);
  });
}
