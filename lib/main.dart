import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lol_champions/config/router/router_config.dart';
import 'package:lol_champions/config/theme/app_theme.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/providers/language_provider.dart';
import 'package:lol_champions/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: language,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      debugShowCheckedModeBanner: false,

      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

      supportedLocales: const [Locale('es'), Locale('en')],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
