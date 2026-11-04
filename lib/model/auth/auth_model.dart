class AuthModel {
  String accessToken;

  AuthModel({required this.accessToken});

  /// Fake Store API returns a simple `{"token": "..."}` payload.
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(accessToken: json['token'] ?? 'No token');
  }
}
