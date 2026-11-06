import 'package:lol_champions/model/champion/champion_model.dart';
import 'package:lol_champions/model/champion/json_parsers.dart';

class ChampionSkin {
  final int num;
  final String name;
  final bool hasChromas;

  const ChampionSkin({
    required this.num,
    required this.name,
    this.hasChromas = false,
  });

  static final _parenthesized = RegExp(r'^(.*\S)\s*\(([^)]+)\)\s*$');
  static final _year = RegExp(r'^\d{4}$');

  // DDragon lists chromas as "<Skin> (<Color>)"; a 4-digit year marks a real skin.
  static List<ChampionSkin> onlyRealSkins(List<ChampionSkin> all) {
    final names = all.map((s) => s.name.trim().toLowerCase()).toSet();
    return all.where((s) {
      if (s.name.toLowerCase().contains('chroma')) return false;
      final match = _parenthesized.firstMatch(s.name);
      if (match == null) return true;
      if (_year.hasMatch(match.group(2)!.trim())) return true;
      return !names.contains(match.group(1)!.trim().toLowerCase());
    }).toList();
  }

  factory ChampionSkin.fromJson(
    Map<String, dynamic> json, {
    required String championName,
  }) {
    final rawName = asString(json['name'], 'default');
    return ChampionSkin(
      num: asInt(json['num']),
      name: rawName == 'default' ? championName : rawName,
      hasChromas: json['chromas'] == true,
    );
  }
}

class ChampionSpell {
  final String id;
  final String name;
  final String description;
  final String imageFull;

  const ChampionSpell({
    required this.id,
    required this.name,
    required this.description,
    required this.imageFull,
  });

  factory ChampionSpell.fromJson(Map<String, dynamic> json) {
    return ChampionSpell(
      id: asString(json['id'], ''),
      name: asString(json['name'], ''),
      description: asString(json['description'], ''),
      imageFull: asString(asMap(json['image'])['full'], ''),
    );
  }
}

class ChampionPassive {
  final String name;
  final String description;
  final String imageFull;

  const ChampionPassive({
    required this.name,
    required this.description,
    required this.imageFull,
  });

  factory ChampionPassive.fromJson(Map<String, dynamic> json) {
    return ChampionPassive(
      name: asString(json['name'], ''),
      description: asString(json['description'], ''),
      imageFull: asString(asMap(json['image'])['full'], ''),
    );
  }
}

class ChampionDetailModel {
  final String id;
  final String key;
  final String name;
  final String title;
  final String lore;
  final List<String> allyTips;
  final List<String> enemyTips;
  final List<String> tags;
  final ChampionInfo info;
  final ChampionStats stats;
  final List<ChampionSkin> skins;
  final List<ChampionSpell> spells;
  final ChampionPassive passive;
  final String version;

  const ChampionDetailModel({
    required this.id,
    required this.key,
    required this.name,
    required this.title,
    required this.lore,
    required this.allyTips,
    required this.enemyTips,
    required this.tags,
    required this.info,
    required this.stats,
    required this.skins,
    required this.spells,
    required this.passive,
    required this.version,
  });

  // Defaults double as skeleton text, so they must have realistic length.
  factory ChampionDetailModel.fromJson(
    Map<String, dynamic> json, {
    String version = '',
  }) {
    final name = asString(json['name'], 'Champion name');
    return ChampionDetailModel(
      id: asString(json['id'], ''),
      key: asString(json['key'], ''),
      name: name,
      title: asString(json['title'], 'Champion title'),
      lore: asString(
        json['lore'],
        'Champion lore shown while the data is loading. It is long enough '
        'to fill several lines of text so the skeleton looks like a '
        'paragraph. Nothing here is real content.',
      ),
      allyTips: asStringList(json['allytips']),
      enemyTips: asStringList(json['enemytips']),
      tags: asStringList(json['tags'], fallback: const ['Tag']),
      info: ChampionInfo.fromJson(asMap(json['info'])),
      stats: ChampionStats.fromJson(asMap(json['stats'])),
      skins: ChampionSkin.onlyRealSkins(
        asMapList(json['skins'])
            .map((s) => ChampionSkin.fromJson(s, championName: name))
            .toList(),
      ),
      spells: asMapList(json['spells']).map(ChampionSpell.fromJson).toList(),
      passive: ChampionPassive.fromJson(asMap(json['passive'])),
      version: version,
    );
  }
}
