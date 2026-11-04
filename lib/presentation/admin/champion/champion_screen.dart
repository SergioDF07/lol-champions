import 'package:flutter/material.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/presentation/admin/champion/champion_form_page.dart';
import 'package:lol_champions/presentation/admin/champion/champion_list_screen.dart';

class ChampionScreen extends StatefulWidget {
  const ChampionScreen({super.key});

  @override
  State<ChampionScreen> createState() => _ChampionScreenState();
}

class _ChampionScreenState extends State<ChampionScreen> {
  int index = 1;
  final List<Widget> _screens = const [
    ChampionFormPage(),
    ChampionListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        body: IndexedStack(index: index, children: _screens),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.add),
              label: l10n.create,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: l10n.browse,
            ),
          ],
          currentIndex: index,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
