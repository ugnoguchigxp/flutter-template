import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/account/presentation/account_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/demos/presentation/api_demo_screen.dart';
import '../../features/demos/presentation/ui_demo_screen.dart';
import '../../features/shared/widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DashboardRoute.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: DashboardRoute.path,
            name: DashboardRoute.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AccountRoute.path,
            name: AccountRoute.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AccountScreen(),
            ),
          ),
          GoRoute(
            path: DemosRoute.path,
            name: DemosRoute.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: UiDemoScreen(),
            ),
          ),
          GoRoute(
            path: ApiDemoRoute.path,
            name: ApiDemoRoute.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ApiDemoScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

class DashboardRoute {
  static const name = 'dashboard';
  static const path = '/dashboard';
}

class AccountRoute {
  static const name = 'account';
  static const path = '/account';
}

class DemosRoute {
  static const name = 'demos';
  static const path = '/demos';
}

class ApiDemoRoute {
  static const name = 'api-demo';
  static const path = '/api-demo';
}
