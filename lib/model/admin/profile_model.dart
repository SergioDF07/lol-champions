class ProfileModel {
  int id;
  String email;
  String username;
  String name;
  String avatar;

  ProfileModel({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.avatar,
  });

  /// Fake Store API's user object nests the name as
  /// `{ "firstname": ..., "lastname": ... }` and has no avatar field.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final nameJson = json['name'] as Map<String, dynamic>? ?? const {};
    final fullName = [
      nameJson['firstname'],
      nameJson['lastname'],
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');

    return ProfileModel(
      id: _parseId(json['id']),
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      name: fullName,
      avatar: json['avatar'] ?? '',
    );
  }

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
