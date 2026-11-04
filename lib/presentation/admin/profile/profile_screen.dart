import 'package:flutter/material.dart';
import 'package:lol_champions/l10n/app_localizations.dart';
import 'package:lol_champions/model/admin/profile_model.dart';
import 'package:lol_champions/services/admin/profile/profile_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel profile = ProfileModel.fromJson({});
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService().getProfile();
    if (!mounted) return;
    setState(() {
      this.profile = profile;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Skeletonizer(
          enabled: _loading,
          enableSwitchAnimation: true,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: scheme.surface,
                  backgroundImage: profile.avatar.isNotEmpty
                      ? NetworkImage(profile.avatar)
                      : null,
                  child: profile.avatar.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 70,
                          color: scheme.onSurface.withValues(alpha: 0.6),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                profile.name.isNotEmpty ? profile.name : '—',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                profile.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _item(
                      context: context,
                      icon: Icons.person,
                      label: l10n.profileName,
                      value: profile.name,
                    ),
                    const Divider(),
                    _item(
                      context: context,
                      icon: Icons.email,
                      label: l10n.profileEmail,
                      value: profile.email,
                    ),
                    const Divider(),
                    _item(
                      context: context,
                      icon: Icons.person_2_rounded,
                      label: l10n.profileUsername,
                      value: profile.username,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: scheme.primary, size: 26),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
