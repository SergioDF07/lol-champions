import 'package:flutter_test/flutter_test.dart';
import 'package:lol_champions/model/champion/champion_detail_model.dart';

void main() {
  group('ChampionSkin.onlyRealSkins', () {
    test('filters out chromas in Spanish and English and keeps real skins and prestige years', () {
      final input = [
        const ChampionSkin(num: 0, name: 'Ahri'),
        const ChampionSkin(num: 1, name: 'Ahri Estrella del Pop'),
        const ChampionSkin(num: 2, name: 'Ahri Estrella del Pop (Cuarzo rosa)'),
        const ChampionSkin(num: 3, name: 'Ahri Estrella del Pop (Rubí)'),
        const ChampionSkin(num: 4, name: 'Ahri K/DA de Prestigio (2022)'),
        const ChampionSkin(num: 5, name: 'Ahri (Chroma)'),
      ];

      final result = ChampionSkin.onlyRealSkins(input);

      expect(result.map((s) => s.name).toList(), [
        'Ahri',
        'Ahri Estrella del Pop',
        'Ahri K/DA de Prestigio (2022)',
      ]);
    });
  });
}
