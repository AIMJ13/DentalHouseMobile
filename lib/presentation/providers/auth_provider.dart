import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/token_model.dart';
import '../../data/repositories/token_repository.dart';
import '../../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final TokenRepository _tokenRepository;

  AuthProvider(this._authService, this._tokenRepository);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TokenModel? _token;
  TokenModel? get token => _token;

  bool get isAuthenticated => _token != null;

  String get currentRole {
    if (_token != null && _token!.roles.isNotEmpty) {
      return _token!.roles.first;
    }
    return '';
  }

  String get userName => _token?.userName ?? '';
  String get email => _token?.email ?? '';
  int get userId => _token?.id ?? 0;
  String get avatarLetra => userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U';

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final tokenModel = await _authService.login(email, password);
      await _tokenRepository.saveToken(tokenModel);
      _token = tokenModel;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Ocurrió un error inesperado al iniciar sesión';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _tokenRepository.removeToken();
    _token = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    _token = await _tokenRepository.getToken();
    _isLoading = false;
    notifyListeners();
  }
}
