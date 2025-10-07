import 'package:flutter_template/bootstrap.dart' as app;
import 'package:flutter_template/src/features/dashboard/presentation/widgets/performance_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user can navigate to UI demos', (tester) async {
    await app.bootstrap();
    await tester.pumpAndSettle();

    expect(find.text('Executive Overview'), findsOneWidget);

    await tester.tap(find.text('UI Demos'));
    await tester.pumpAndSettle();

    expect(find.text('UI Components Demo'), findsOneWidget);
    expect(find.byType(PerformanceChart), findsOneWidget);
  });
}
