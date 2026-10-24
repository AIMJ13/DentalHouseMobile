import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/token_model.dart';
import '../../data/repositories/token_repository.dart';
import '../../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final TokenRepository _tokenRepository;

  AuthProvider(this._authService, this._tokenRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TokenModel? _token;
  TokenModel? get token => _token;

  bool get isAuthenticated => _token != null;

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
    _token = await _tokenRepository.getToken();
    notifyListeners();
  }
}
