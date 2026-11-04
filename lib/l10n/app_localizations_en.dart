// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LoL Champions';

  @override
  String get drawerSubtitle => 'Powered by Riot Data Dragon';

  @override
  String get champions => 'Champions';

  @override
  String get championDetail => 'Champion';

  @override
  String get create => 'Create';

  @override
  String get browse => 'Browse';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get searchHint => 'Search champions';

  @override
  String get noResults => 'No champions found';

  @override
  String get loadError => 'Could not load data';

  @override
  String get retry => 'Retry';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldBlurb => 'Blurb';

  @override
  String get fieldTags => 'Tags (comma separated)';

  @override
  String get fieldImageUrl => 'Image URL';

  @override
  String get required => 'Required';

  @override
  String get submit => 'Submit';

  @override
  String get creationDisabled =>
      'Creation is disabled because Data Dragon is read-only.';

  @override
  String get infoAttack => 'Attack';

  @override
  String get infoDefense => 'Defense';

  @override
  String get infoMagic => 'Magic';

  @override
  String get infoDifficulty => 'Difficulty';

  @override
  String get lore => 'Lore';

  @override
  String get stats => 'Stats';

  @override
  String get statHp => 'Health';

  @override
  String get statMp => 'Mana';

  @override
  String get statMoveSpeed => 'Move speed';

  @override
  String get statArmor => 'Armor';

  @override
  String get statAttackRange => 'Attack range';

  @override
  String get spells => 'Abilities';

  @override
  String get passive => 'Passive';

  @override
  String get skinsTitle => 'Skins';

  @override
  String get tips => 'Tips';

  @override
  String get allyTips => 'Playing as ally';

  @override
  String get enemyTips => 'Playing against';

  @override
  String get backToList => 'Back to champions';

  @override
  String get errorTimeout => 'The connection timed out.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorServer => 'Server error. Try again later.';

  @override
  String get errorNoConnection =>
      'No internet connection or the server is not responding.';

  @override
  String get errorUnexpected => 'An unexpected error occurred.';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get completeFields => 'Please complete all fields';

  @override
  String get profile => 'Profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileRole => 'Role';

  @override
  String get profileUsername => 'Username';

  @override
  String get logout => 'Log out';
}
