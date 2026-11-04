import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/model/champion/champion_model.dart';
import 'package:lol_champions/providers/champion_provider.dart';
import 'package:lol_champions/presentation/shared/error/error_view.dart';
import 'package:lol_champions/services/ddragon/ddragon_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChampionListScreen extends ConsumerStatefulWidget {
  const ChampionListScreen({super.key});

  @override
  ConsumerState<ChampionListScreen> createState() => _ChampionListScreenState();
}

class _ChampionListScreenState extends ConsumerState<ChampionListScreen> {
  static final _placeholder = List.generate(
    8,
    (_) => ChampionModel.fromJson(const {}),
  );

  String query = '';

  void sendToDetail(String id) {
    context.push('/champions/$id');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final champions = ref.watch(championListProvider);

    return Scaffold(
      body: champions.when(
        skipLoadingOnReload: false,
        loading: () => _buildList(l10n, _placeholder, loading: true),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(championListProvider),
        ),
        data: (items) {
          final needle = query.trim().toLowerCase();
          final filtered = needle.isEmpty
              ? items
              : items
                    .where((c) => c.name.toLowerCase().contains(needle))
                    .toList();
          return _buildList(l10n, filtered);
        },
      ),
    );
  }

  Widget _buildList(
    AppLocalizations l10n,
    List<ChampionModel> items, {
    bool loading = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            enabled: !loading,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => setState(() => query = value),
          ),
        ),
        Expanded(
          child: Skeletonizer(
            enabled: loading,
            enableSwitchAnimation: true,
            child: items.isEmpty
                ? Center(child: Text(l10n.noResults))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    itemBuilder: (context, index) => _ChampionTile(
                      champion: items[index],
                      onTap: sendToDetail,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _ChampionTile extends StatelessWidget {
  final ChampionModel champion;
  final void Function(String id) onTap;

  const _ChampionTile({required this.champion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onTap(champion.id),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImageCustom(
                src: DdragonService.iconUrl(
                  champion.version,
                  champion.imageFull,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      champion.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      champion.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: scheme.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      champion.blurb,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: champion.tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              labelStyle: const TextStyle(fontSize: 11),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Center(child: Icon(Icons.chevron_right)),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageCustom extends StatelessWidget {
  final String src;

  const ImageCustom({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.image_not_supported, size: 35),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 110,
        child: src.isEmpty
            ? placeholder
            : Image.network(
                src,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
