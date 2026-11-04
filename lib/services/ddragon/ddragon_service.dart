import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:lol_champions/model/champion/champion_detail_model.dart';
import 'package:lol_champions/model/champion/champion_model.dart';
import 'package:lol_champions/model/champion/json_parsers.dart';

enum DdragonError { timeout, notFound, server, noConnection, unexpected }

class DdragonException implements Exception {
  final DdragonError error;

  const DdragonException(this.error);

  @override
  String toString() => 'DdragonException(${error.name})';
}

class DdragonService {
  static const _base = 'https://ddragon.leagueoflegends.com';

  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static Future<String>? _versionFuture;

  static String localeFor(Locale locale) {
    return locale.languageCode == 'es' ? 'es_MX' : 'en_US';
  }

  static String iconUrl(String version, String imageFull) {
    if (version.isEmpty || imageFull.isEmpty) return '';
    return '$_base/cdn/$version/img/champion/$imageFull';
  }

  static String splashUrl(String id, int skinNum) {
    return '$_base/cdn/img/champion/splash/${id}_$skinNum.jpg';
  }

  static String loadingUrl(String id, int skinNum) {
    return '$_base/cdn/img/champion/loading/${id}_$skinNum.jpg';
  }

  static String passiveUrl(String version, String imageFull) {
    if (version.isEmpty || imageFull.isEmpty) return '';
    return '$_base/cdn/$version/img/passive/$imageFull';
  }

  static String spellUrl(String version, String imageFull) {
    if (version.isEmpty || imageFull.isEmpty) return '';
    return '$_base/cdn/$version/img/spell/$imageFull';
  }

  static Future<String> getVersion() {
    final cached = _versionFuture;
    if (cached != null) return cached;

    final future = _fetchVersion();
    _versionFuture = future;
    future.catchError((_) {
      _versionFuture = null;
      return '';
    });
    return future;
  }

  static Future<String> _fetchVersion() async {
    final data = await _get('$_base/api/versions.json');
    if (data is List && data.isNotEmpty && data.first is String) {
      return data.first as String;
    }
    throw const DdragonException(DdragonError.unexpected);
  }

  static Future<List<ChampionModel>> getChampions(String locale) async {
    final version = await getVersion();
    final data = await _get('$_base/cdn/$version/data/$locale/champion.json');
    final champions = asMap(asMap(data)['data']);
    return champions.values
        .map((item) => ChampionModel.fromJson(asMap(item), version: version))
        .toList();
  }

  static Future<ChampionDetailModel> getDetail(String id, String locale) async {
    final version = await getVersion();
    final data = await _get(
      '$_base/cdn/$version/data/$locale/champion/$id.json',
    );
    final champion = asMap(asMap(data)['data'])[id];
    if (champion == null) {
      throw const DdragonException(DdragonError.notFound);
    }
    return ChampionDetailModel.fromJson(asMap(champion), version: version);
  }

  static Future<dynamic> _get(String url) async {
    try {
      final response = await _dio.get<dynamic>(url);
      return response.data;
    } on DioException catch (e) {
      throw DdragonException(_mapError(e));
    }
  }

  static DdragonError _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DdragonError.timeout;
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        if (status == 403 || status == 404) return DdragonError.notFound;
        if (status >= 500) return DdragonError.server;
        return DdragonError.unexpected;
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return DdragonError.noConnection;
      default:
        return DdragonError.unexpected;
    }
  }
}
