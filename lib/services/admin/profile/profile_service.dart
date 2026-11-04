import 'package:dio/dio.dart';
import 'package:lol_champions/helpers/interceptor.dart';
import 'package:lol_champions/model/admin/profile_model.dart';

class ProfileService {
  static final _dio = Dio()..interceptors.add(AuthInterceptor());
  static const _url = 'https://fakestoreapi.com';

  /// Fake Store API has no "me" endpoint that resolves the current user
  /// from the token, so this fetches the fixed demo user (id 2, the
  /// "mor_2314" account) that AuthService logs in with.
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dio.get('$_url/users/2');
      if (response.statusCode != 200) {
        return ProfileModel.fromJson({});
      }
      return ProfileModel.fromJson(response.data);
    } catch (_) {
      return ProfileModel.fromJson({});
    }
  }
}
