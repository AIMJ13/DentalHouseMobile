import '../data/repositories/user_repository.dart';

class UserService {
  final UserRepository repo;

  UserService(this.repo);

  void callRepo() => repo.callApiClient();
}
