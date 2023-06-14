import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _userTokenKey = 'user_token';
  static const String _userIdKey = 'user_id';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveUserToken(String token) async {
    final prefs = await _prefs;
    prefs.setString(_userTokenKey, token);
  }

  Future<void> saveUserId(int userId) async {
    final prefs = await _prefs;
    prefs.setInt(_userIdKey, userId);
  }

  Future<String?> getUserToken() async {
    final prefs = await _prefs;
    return prefs.getString(_userTokenKey);
  }

  Future<int?> getUserId() async {
    final prefs = await _prefs;
    return prefs.getInt(_userIdKey);
  }

  Future<void> removeUserToken() async {
    final prefs = await _prefs;
    prefs.remove(_userTokenKey);
  }
}
