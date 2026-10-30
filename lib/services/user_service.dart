import '../core/errors/app_exceptions.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class UserService {
  final UserRepository repo;

  UserService(this.repo);

  Future<dynamic> getAll() async {
    return await repo.getAll();
  }

  Future<UserModel> getById(int id) async {
    return await repo.getById(id);
  }

  Future<UserModel> getProfile() async {
    return await repo.getProfile();
  }

  Future<List<UserModel>> getUsers() async {
    return await repo.getUsers();
  }

  Future<void> setState(int id, bool state) async {
    if (id <= 0) {
      throw const ValidationException('Usuario no válido');
    }
    await repo.setState(id, state);
  }
    Future<void> changePassword(String actual, String nueva, String confirmar) async {
    if (actual.isEmpty || nueva.isEmpty || confirmar.isEmpty) {
      throw const ValidationException('Completa todos los campos de contraseña');
    }
    if (nueva != confirmar) {
      throw const ValidationException('La nueva contraseña y la confirmación no coinciden');
    }
    if (nueva.length < 6) {
      throw const ValidationException('La contraseña debe tener al menos 6 caracteres');
    }
    await repo.changePassword(actual, nueva);
  }

  Future<void> resetPassword(int id, String nueva) async {
    if (id <= 0) {
      throw const ValidationException('Usuario no válido');
    }
    if (nueva.length < 6) {
      throw const ValidationException('La contraseña debe tener al menos 6 caracteres');
    }
    await repo.resetPassword(id, nueva);
  }
}