import 'package:flutter/material.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/services/ddragon/ddragon_service.dart';

String errorMessage(AppLocalizations l10n, Object error) {
  if (error is DdragonException) {
    switch (error.error) {
      case DdragonError.timeout:
        return l10n.errorTimeout;
      case DdragonError.notFound:
        return l10n.errorNotFound;
      case DdragonError.server:
        return l10n.errorServer;
      case DdragonError.noConnection:
        return l10n.errorNoConnection;
      case DdragonError.unexpected:
        return l10n.errorUnexpected;
    }
  }
  return l10n.errorUnexpected;
}

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(
              l10n.loadError,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              errorMessage(l10n, error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
