import 'package:flutter/material.dart';
import 'package:lol_champions/config/router/router_model.dart';
import 'package:lol_champions/presentation/admin/champion/champion_detail_screen.dart';
import 'package:lol_champions/presentation/admin/champion/champion_screen.dart';
import 'package:lol_champions/presentation/admin/profile/profile_screen.dart';

final routerConfigAdmin = <RouterModel>[
  RouterModel(
    name: 'champions',
    screen: (context, state) => const ChampionScreen(),
    label: (l10n) => l10n.champions,
    patch: '/champions',
    icon: Icons.shield,
  ),
  RouterModel(
    name: 'champion-detail',
    screen: (context, state) =>
        ChampionDetailScreen(id: state.pathParameters['id'] ?? ''),
    label: (l10n) => l10n.championDetail,
    patch: '/champions/:id',
    icon: Icons.shield,
    inDrawer: false,
  ),
  RouterModel(
    name: 'profile',
    screen: (context, state) => const ProfileScreen(),
    label: (l10n) => l10n.profile,
    patch: '/profile',
    icon: Icons.person,
  ),
];
