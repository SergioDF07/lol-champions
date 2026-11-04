import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lol_champions/model/champion/champion_detail_model.dart';
import 'package:lol_champions/model/champion/champion_model.dart';
import 'package:lol_champions/providers/language_provider.dart';
import 'package:lol_champions/services/ddragon/ddragon_service.dart';

// Riverpod 3 retries failed providers by default; errors should reach the UI instead.
Duration? _noRetry(int retryCount, Object error) => null;

final ddragonLocaleProvider = Provider<String>((ref) {
  final code = ref.watch(languageProvider.select((l) => l.languageCode));
  return DdragonService.localeFor(Locale(code));
});

final championListProvider = FutureProvider<List<ChampionModel>>((ref) async {
  final locale = ref.watch(ddragonLocaleProvider);
  final champions = await DdragonService.getChampions(locale);
  return champions..sort((a, b) => a.name.compareTo(b.name));
}, retry: _noRetry);

final championDetailProvider =
    FutureProvider.family<ChampionDetailModel, String>((ref, id) {
      final locale = ref.watch(ddragonLocaleProvider);
      return DdragonService.getDetail(id, locale);
    }, retry: _noRetry);
