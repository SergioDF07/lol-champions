import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lol_champions/main.dart';
import 'package:lol_champions/model/champion/champion_model.dart';
import 'package:lol_champions/providers/champion_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows the champion list without hitting the network', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'languageCode': 'en'});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          championListProvider.overrideWith(
            (ref) async => [
              ChampionModel.fromJson(const {
                'id': 'Aatrox',
                'name': 'Aatrox',
                'title': 'the Darkin Blade',
                'blurb': 'A fallen defender of Shurima.',
                'tags': ['Fighter'],
              }),
            ],
          ),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aatrox'), findsOneWidget);
    expect(find.text('the Darkin Blade'), findsOneWidget);
    expect(find.text('Explorar'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
