import 'package:lol_champions/model/champion/json_parsers.dart';

class ChampionInfo {
  final int attack;
  final int defense;
  final int magic;
  final int difficulty;

  const ChampionInfo({
    required this.attack,
    required this.defense,
    required this.magic,
    required this.difficulty,
  });

  factory ChampionInfo.fromJson(Map<String, dynamic> json) {
    return ChampionInfo(
      attack: asInt(json['attack']),
      defense: asInt(json['defense']),
      magic: asInt(json['magic']),
      difficulty: asInt(json['difficulty']),
    );
  }
}

class ChampionStats {
  final double hp;
  final double mp;
  final double moveSpeed;
  final double armor;
  final double attackRange;

  const ChampionStats({
    required this.hp,
    required this.mp,
    required this.moveSpeed,
    required this.armor,
    required this.attackRange,
  });

  factory ChampionStats.fromJson(Map<String, dynamic> json) {
    return ChampionStats(
      hp: asDouble(json['hp']),
      mp: asDouble(json['mp']),
      moveSpeed: asDouble(json['movespeed']),
      armor: asDouble(json['armor']),
      attackRange: asDouble(json['attackrange']),
    );
  }
}

class ChampionModel {
  final String id;
  final String key;
  final String name;
  final String title;
  final String blurb;
  final List<String> tags;
  final ChampionInfo info;
  final ChampionStats stats;
  final String imageFull;
  final String version;

  const ChampionModel({
    required this.id,
    required this.key,
    required this.name,
    required this.title,
    required this.blurb,
    required this.tags,
    required this.info,
    required this.stats,
    required this.imageFull,
    required this.version,
  });

  // Defaults double as skeleton text, so they must have realistic length.
  factory ChampionModel.fromJson(
    Map<String, dynamic> json, {
    String version = '',
  }) {
    return ChampionModel(
      id: asString(json['id'], ''),
      key: asString(json['key'], ''),
      name: asString(json['name'], 'Champion name'),
      title: asString(json['title'], 'Champion title'),
      blurb: asString(
        json['blurb'],
        'Champion description shown while the data is loading, '
        'long enough to fill a few lines of text.',
      ),
      tags: asStringList(json['tags'], fallback: const ['Tag']),
      info: ChampionInfo.fromJson(asMap(json['info'])),
      stats: ChampionStats.fromJson(asMap(json['stats'])),
      imageFull: asString(asMap(json['image'])['full'], ''),
      version: version,
    );
  }
}
