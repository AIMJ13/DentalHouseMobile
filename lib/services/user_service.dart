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
}
