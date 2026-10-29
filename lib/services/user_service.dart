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
}