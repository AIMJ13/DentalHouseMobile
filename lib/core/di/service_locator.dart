import 'package:get_it/get_it.dart';
import '../networks/api_client.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/user_service.dart';
import '../../presentation/providers/login_provider.dart';

final sl = GetIt.instance;

void configure() {
  sl.registerSingleton<ApiClient>(ApiClient());
  sl.registerSingleton<UserRepository>(UserRepository(sl<ApiClient>()));
  sl.registerSingleton<UserService>(UserService(sl<UserRepository>()));
  sl.registerSingleton<LoginProvider>(LoginProvider(sl<UserService>()));
}
