import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/model/champion/champion_detail_model.dart';
import 'package:lol_champions/presentation/shared/error/error_view.dart';
import 'package:lol_champions/presentation/shared/images/images_widget.dart';
import 'package:lol_champions/providers/champion_provider.dart';
import 'package:lol_champions/services/ddragon/ddragon_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChampionDetailScreen extends ConsumerWidget {
  final String id;

  const ChampionDetailScreen({super.key, required this.id});

  static final _placeholder = ChampionDetailModel.fromJson(const {});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(championDetailProvider(id));

    return Scaffold(
      body: SafeArea(
        child: detail.when(
          skipLoadingOnReload: false,
          loading: () => _DetailBody(data: _placeholder, loading: true),
          error: (error, _) => ErrorView(
            error: error,
            onRetry: () => ref.invalidate(championDetailProvider(id)),
          ),
          data: (data) => _DetailBody(data: data),
        ),
      ),
    );
  }
}

class _DetailBody extends StatefulWidget {
  final ChampionDetailModel data;
  final bool loading;

  const _DetailBody({required this.data, this.loading = false});

  @override
  State<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<_DetailBody> {
  int _selectedSpell = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final data = widget.data;
    final skins = data.skins;

    return Skeletonizer(
      enabled: widget.loading,
      enableSwitchAnimation: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroHeader(data: data),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: data.tags
                  .map(
                    (t) => Chip(
                      avatar: Icon(
                        _tagIcon(t),
                        size: 16,
                        color: scheme.primary,
                      ),
                      label: Text(t),
                      backgroundColor: scheme.surfaceContainerHighest,
                      side: BorderSide(color: scheme.outlineVariant),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            ImagesWidget(
              height: 280,
              images: skins
                  .map((s) => DdragonService.splashUrl(data.id, s.num))
                  .toList(),
              captions: skins.map((s) => s.name).toList(),
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: l10n.stats,
              icon: Icons.bar_chart,
              child: Column(
                children: [
                  _CombatRating(
                    label: l10n.infoAttack,
                    value: data.info.attack,
                    color: Colors.redAccent,
                  ),
                  _CombatRating(
                    label: l10n.infoDefense,
                    value: data.info.defense,
                    color: Colors.green,
                  ),
                  _CombatRating(
                    label: l10n.infoMagic,
                    value: data.info.magic,
                    color: Colors.blueAccent,
                  ),
                  _CombatRating(
                    label: l10n.infoDifficulty,
                    value: data.info.difficulty,
                    color: Colors.purpleAccent,
                  ),
                  const Divider(height: 24),
                  _StatGrid(data: data),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n.spells,
              icon: Icons.auto_fix_high,
              child: _AbilitiesSection(
                data: data,
                selectedIndex: _selectedSpell,
                onSelect: (index) {
                  setState(() {
                    _selectedSpell = _selectedSpell == index ? -1 : index;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: l10n.lore,
              icon: Icons.menu_book,
              child: Text(
                data.lore,
                textAlign: TextAlign.justify,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
            if (data.allyTips.isNotEmpty || data.enemyTips.isNotEmpty) ...[
              const SizedBox(height: 16),
              _TipsSection(data: data),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.backToList),
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  IconData _tagIcon(String tag) {
    switch (tag.toLowerCase()) {
      case 'fighter':
        return Icons.sports_martial_arts;
      case 'mage':
        return Icons.auto_awesome;
      case 'assassin':
        return Icons.flash_on;
      case 'tank':
        return Icons.shield;
      case 'marksman':
        return Icons.track_changes;
      case 'support':
        return Icons.favorite;
      default:
        return Icons.military_tech;
    }
  }
}

class _HeroHeader extends StatelessWidget {
  final ChampionDetailModel data;

  const _HeroHeader({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final iconUrl = DdragonService.iconUrl(data.version, '${data.id}.png');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 72,
            height: 72,
            color: scheme.surfaceContainerHighest,
            child: iconUrl.isEmpty
                ? const Icon(Icons.shield, size: 36)
                : Image.network(
                    iconUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.shield, size: 36),
                  ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.title.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CombatRating extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _CombatRating({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (value / 10).clamp(0.0, 1.0),
                minHeight: 8,
                color: color,
                backgroundColor: color.withValues(alpha: 0.2),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 24,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final ChampionDetailModel data;

  const _StatGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = data.stats;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _StatChip(
          icon: Icons.favorite,
          label: l10n.statHp,
          value: '${stats.hp.toInt()}',
          color: Colors.redAccent,
        ),
        _StatChip(
          icon: Icons.bolt,
          label: l10n.statMp,
          value: '${stats.mp.toInt()}',
          color: Colors.lightBlue,
        ),
        _StatChip(
          icon: Icons.shield,
          label: l10n.statArmor,
          value: '${stats.armor.toInt()}',
          color: Colors.amber,
        ),
        _StatChip(
          icon: Icons.directions_run,
          label: l10n.statMoveSpeed,
          value: '${stats.moveSpeed.toInt()}',
          color: Colors.teal,
        ),
        _StatChip(
          icon: Icons.my_location,
          label: l10n.statAttackRange,
          value: '${stats.attackRange.toInt()}',
          color: Colors.deepOrange,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AbilitiesSection extends StatelessWidget {
  final ChampionDetailModel data;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _AbilitiesSection({
    required this.data,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final keys = ['Q', 'W', 'E', 'R'];

    final items = <_AbilityItem>[
      _AbilityItem(
        keyTag: 'P',
        name: data.passive.name,
        description: data.passive.description,
        imageUrl: DdragonService.passiveUrl(
          data.version,
          data.passive.imageFull,
        ),
        isPassive: true,
      ),
      for (var i = 0; i < data.spells.length; i++)
        _AbilityItem(
          keyTag: i < keys.length ? keys[i] : '',
          name: data.spells[i].name,
          description: data.spells[i].description,
          imageUrl: DdragonService.spellUrl(
            data.version,
            data.spells[i].imageFull,
          ),
          isPassive: false,
        ),
    ];

    final active = selectedIndex >= 0 && selectedIndex < items.length
        ? items[selectedIndex]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final it = items[i];
            final isSelected = selectedIndex == i;
            return InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? scheme.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 48,
                            height: 48,
                            color: scheme.surfaceContainerHighest,
                            child: it.imageUrl.isEmpty
                                ? const Icon(Icons.flash_on, size: 24)
                                : Image.network(
                                    it.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) =>
                                        const Icon(Icons.flash_on, size: 24),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              it.keyTag,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: scheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 56,
                      child: Text(
                        it.isPassive ? l10n.passive : it.keyTag,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        if (active != null) ...[
          const Divider(height: 20),
          Row(
            children: [
              Text(
                active.keyTag.isEmpty ? '' : '[${active.keyTag}] ',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  active.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _cleanHtml(active.description),
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ],
      ],
    );
  }

  String _cleanHtml(String raw) {
    return raw
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

class _AbilityItem {
  final String keyTag;
  final String name;
  final String description;
  final String imageUrl;
  final bool isPassive;

  const _AbilityItem({
    required this.keyTag,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isPassive,
  });
}

class _TipsSection extends StatelessWidget {
  final ChampionDetailModel data;

  const _TipsSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _SectionCard(
      title: l10n.tips,
      icon: Icons.lightbulb,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.allyTips.isNotEmpty) ...[
            Text(
              l10n.allyTips,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ...data.allyTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
            ),
          ],
          if (data.allyTips.isNotEmpty && data.enemyTips.isNotEmpty)
            const SizedBox(height: 8),
          if (data.enemyTips.isNotEmpty) ...[
            Text(
              l10n.enemyTips,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ...data.enemyTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
