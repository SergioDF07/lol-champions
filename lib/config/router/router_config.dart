import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_champions/config/router/router_admin.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/presentation/admin/layout/layout.dart';
import 'package:lol_champions/presentation/public/auth/auth_screen.dart';

final storage = FlutterSecureStorage();

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final token = await storage.read(key: 'token');
    final isLoginRoute = state.matchedLocation == '/';

    if (token == null || token.isEmpty) {
      return isLoginRoute ? null : '/';
    }

    if (isLoginRoute) {
      return '/champions';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const AuthScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final current = routerConfigAdmin.firstWhere(
          (route) => route.name == state.topRoute?.name,
          orElse: () => routerConfigAdmin.first,
        );
        return Layout(
          title: current.label(AppLocalizations.of(context)!),
          child: child,
        );
      },
      routes: [
        ...routerConfigAdmin.map((screen) {
          return GoRoute(
            path: screen.patch,
            builder: screen.screen,
            name: screen.name,
          );
        }),
      ],
    ),
  ],
);
