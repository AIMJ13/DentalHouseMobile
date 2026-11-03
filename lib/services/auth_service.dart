import '../core/constant/app_regex.dart';
import '../core/errors/app_exceptions.dart';
import '../data/models/token_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<TokenModel> login(String userName, String password) async {
    final sanitizedUser = userName.trim();
    final sanitizedPassword = password.trim();

    if (sanitizedUser.isEmpty) {
      throw const ValidationException('El usuario o correo es requerido');
    }

    if (sanitizedPassword.isEmpty) {
      throw const ValidationException('La contraseña es requerida');
    }

    if (sanitizedPassword.length < 5) {
      throw const ValidationException('La contraseña debe tener al menos 5 caracteres');
    }

    if (sanitizedUser.contains('@') && !AppRegex.emailRegex.hasMatch(sanitizedUser)) {
      throw const ValidationException('El formato de correo no es válido');
    }

    return await _authRepository.login(sanitizedUser, sanitizedPassword);
  }
}
