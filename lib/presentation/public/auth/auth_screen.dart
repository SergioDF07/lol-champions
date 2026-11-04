import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/presentation/public/auth/header_widget.dart';
import 'package:lol_champions/providers/theme_provider.dart';
import 'package:lol_champions/services/auth/auth_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.completeFields)));
      return;
    }

    setState(() => _loading = true);

    final error = await AuthService.login(
      _userController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (error == null) {
      context.goNamed('champions');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const HeaderWidget(200),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      /// USERNAME
                      TextFormField(
                        controller: _userController,
                        decoration: InputDecoration(
                          labelText: l10n.username,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? l10n.usernameRequired
                              : null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          return value == null || value.isEmpty
                              ? l10n.passwordRequired
                              : null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          label: Text(l10n.login),
                          onPressed: _loading ? null : () => _login(context),
                          icon: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.login),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// THEME BUTTON
                      IconButton.filled(
                        onPressed: () =>
                            ref.read(themeProvider.notifier).toggleTheme(),
                        icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
