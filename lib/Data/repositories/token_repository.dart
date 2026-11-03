import 'package:shared_preferences/shared_preferences.dart';
import '../models/token_model.dart';

class TokenRepository {
  final SharedPreferences _prefs;

  TokenRepository(this._prefs);

  static const String _keyAccessToken = 'access_token';
  static const String _keyTokenType = 'token_type';
  static const String _keyExpiresIn = 'expires_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRoles = 'user_roles';

  Future<TokenModel?> getToken() async {
    final token = _prefs.getString(_keyAccessToken);
    if (token == null || token.isEmpty) return null;

    final tokenType = _prefs.getString(_keyTokenType) ?? 'Bearer';
    final expiresIn = _prefs.getInt(_keyExpiresIn) ?? 0;
    final userId = _prefs.getInt(_keyUserId) ?? 0;
    final userName = _prefs.getString(_keyUserName) ?? '';
    final userEmail = _prefs.getString(_keyUserEmail) ?? '';
    final userRoles = _prefs.getStringList(_keyUserRoles) ?? [];

    return TokenModel(
      accessToken: token,
      tokenType: tokenType,
      expiresIn: expiresIn,
      id: userId,
      userName: userName,
      email: userEmail,
      roles: userRoles,
    );
  }

  Future<bool> saveToken(TokenModel token) async {
    final savedToken = await _prefs.setString(_keyAccessToken, token.accessToken);
    await _prefs.setString(_keyTokenType, token.tokenType);
    await _prefs.setInt(_keyExpiresIn, token.expiresIn);
    await _prefs.setInt(_keyUserId, token.id);
    await _prefs.setString(_keyUserName, token.userName);
    await _prefs.setString(_keyUserEmail, token.email);
    await _prefs.setStringList(_keyUserRoles, token.roles);
    return savedToken;
  }

  Future<bool> removeToken() async {
    await _prefs.remove(_keyTokenType);
    await _prefs.remove(_keyExpiresIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserRoles);
    return await _prefs.remove(_keyAccessToken);
  }
}
