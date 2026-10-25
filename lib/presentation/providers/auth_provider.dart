import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/dashboard_data.dart';
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
    final rolPerfil = perfilUsuarioActual['rol'] as String? ?? '';
    if (rolPerfil.isNotEmpty) {
      return rolPerfil;
    }
    return '';
  }

  void _syncPerfil(TokenModel token) {
    final rol = token.roles.isNotEmpty ? token.roles.first : 'Administrador';
    perfilUsuarioActual['id'] = token.id;
    perfilUsuarioActual['nombre'] = token.userName;
    perfilUsuarioActual['usuario'] = token.userName;
    perfilUsuarioActual['rol'] = rol;
    perfilUsuarioActual['email'] = token.email;
    perfilUsuarioActual['avatarLetra'] = token.userName.isNotEmpty
        ? token.userName.substring(0, 1).toUpperCase()
        : 'U';
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final tokenModel = await _authService.login(email, password);
      await _tokenRepository.saveToken(tokenModel);
      _syncPerfil(tokenModel);
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
    perfilUsuarioActual['id'] = '';
    perfilUsuarioActual['nombre'] = '';
    perfilUsuarioActual['usuario'] = '';
    perfilUsuarioActual['rol'] = '';
    perfilUsuarioActual['email'] = '';
    perfilUsuarioActual['avatarLetra'] = '';
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    _token = await _tokenRepository.getToken();
    if (_token != null) {
      _syncPerfil(_token!);
    }
    _isLoading = false;
    notifyListeners();
  }
}
