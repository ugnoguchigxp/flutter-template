import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/router/app_router.dart';
import '../../../core/i18n/app_localizations.dart';

class AppShell extends HookConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  List<_AppDestination> _getDestinations(BuildContext context) {
    return [
      _AppDestination(
        label: context.tr('nav.dashboard'),
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        route: DashboardRoute.path,
      ),
      _AppDestination(
        label: context.tr('nav.ui_demos'),
        icon: Icons.science_outlined,
        activeIcon: Icons.science,
        route: DemosRoute.path,
      ),
      _AppDestination(
        label: context.tr('nav.api_demo'),
        icon: Icons.api_outlined,
        activeIcon: Icons.api,
        route: ApiDemoRoute.path,
      ),
      _AppDestination(
        label: context.tr('nav.account'),
        icon: Icons.account_circle_outlined,
        activeIcon: Icons.account_circle,
        route: AccountRoute.path,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinations = _getDestinations(context);
    final location = GoRouterState.of(context).uri.toString();
    final index = destinations.indexWhere(
      (destination) => _matchesRoute(destination.route, location),
    );
    final selectedIndex = index == -1 ? 0 : index;

    final isWide = MediaQuery.sizeOf(context).width >= 960;

    void onTap(int index) {
      final target = destinations[index];
      if (!_matchesRoute(target.route, location)) {
        context.go(target.route);
      }
    }

    return Scaffold(
      drawer: isWide
          ? null
          : Drawer(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _AppDrawerHeader(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final destination = destinations[index];
                          final selected = selectedIndex == index;
                          return ListTile(
                            leading: Icon(
                              selected
                                  ? destination.activeIcon
                                  : destination.icon,
                            ),
                            title: Text(destination.label),
                            selected: selected,
                            onTap: () {
                              Navigator.of(context).pop();
                              onTap(index);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onTap,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final destination in destinations)
                    NavigationRailDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.activeIcon),
                      label: Text(destination.label),
                    ),
                ],
              ),
            if (isWide) const VerticalDivider(width: 1),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: child,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              destinations: [
                for (final destination in destinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.activeIcon),
                    label: destination.label,
                  ),
              ],
              onDestinationSelected: onTap,
            ),
    );
  }
}

class _AppDestination {
  const _AppDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
}

class _AppDrawerHeader extends StatelessWidget {
  const _AppDrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.dashboard_customize,
              size: 36,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(context.tr('app.title'), style: theme.textTheme.titleLarge),
            Text(
              context.tr('app.subtitle'),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

bool _matchesRoute(String route, String location) {
  return location == route || location.startsWith('$route/');
}
