import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/account/presentation/account_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/demos/presentation/api_demo_screen.dart';
import '../../features/game/presentation/drag_speed_game_screen.dart';
import '../../features/game/presentation/games_list_screen.dart';
import '../../features/reflex_test/presentation/reflex_game_screen.dart';
import '../../features/shared/widgets/app_shell.dart';
import '../../features/tetris/presentation/tetris_game_screen.dart';

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
            path: GameRoute.path,
            name: GameRoute.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GamesListScreen(),
            ),
            routes: [
              GoRoute(
                path: 'drag-speed',
                name: DragSpeedGameRoute.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DragSpeedGameScreen(),
                ),
              ),
              GoRoute(
                path: 'tetris',
                name: TetrisGameRoute.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TetrisGameScreen(),
                ),
              ),
              GoRoute(
                path: 'reflex',
                name: ReflexGameRoute.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ReflexGameScreen(),
                ),
              ),
            ],
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

class GameRoute {
  static const name = 'game';
  static const path = '/game';
}

class DragSpeedGameRoute {
  static const name = 'drag-speed-game';
  static const path = '/game/drag-speed';
}

class TetrisGameRoute {
  static const name = 'tetris-game';
  static const path = '/game/tetris';
}

class ReflexGameRoute {
  static const name = 'reflex-game';
  static const path = '/game/reflex';
}

class ApiDemoRoute {
  static const name = 'api-demo';
  static const path = '/api-demo';
}
