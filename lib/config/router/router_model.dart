import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_champions/l10n/app_localizations.dart';

class RouterModel {
  final String name;
  final GoRouterWidgetBuilder screen;
  final String Function(AppLocalizations l10n) label;
  final String patch;
  final IconData icon;
  final bool inDrawer;

  const RouterModel({
    required this.name,
    required this.screen,
    required this.label,
    required this.patch,
    required this.icon,
    this.inDrawer = true,
  });
}
