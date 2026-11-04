import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_champions/config/router/router_admin.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/providers/theme_provider.dart';
import 'package:lol_champions/services/auth/auth_service.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final isDark = ref.watch(themeProvider);
    final drawerRoutes = routerConfigAdmin.where((res) => res.inDrawer);
    final currentLocation = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .last
        .matchedLocation;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: scheme.primaryContainer),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: scheme.primary,
                    child: Icon(
                      Icons.shield,
                      size: 32,
                      color: scheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.drawerSubtitle,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: scheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
          ),
          ...drawerRoutes.map((res) {
            final isSelected = currentLocation == res.patch;

            return ListTile(
              selected: isSelected,
              selectedTileColor: scheme.secondaryContainer,
              title: Text(res.label(l10n)),
              leading: Icon(res.icon),
              onTap: () {
                Navigator.pop(context);
                if (!isSelected) {
                  context.go(res.patch);
                }
              },
            );
          }),
          const Spacer(),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: Text(l10n.darkMode),
            value: isDark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 'es', label: Text('ES')),
                ButtonSegment(value: 'en', label: Text('EN'), enabled: false),
              ],
              selected: const {'es'},
              onSelectionChanged: (_) {},
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () async {
              Navigator.pop(context);
              await AuthService.logout();
              if (context.mounted) context.go('/');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
