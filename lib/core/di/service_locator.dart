import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networks/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/token_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../presentation/providers/auth_provider.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<TokenRepository>(() => TokenRepository(sl<SharedPreferences>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<ApiClient>()));
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl<ApiClient>()));

  sl.registerLazySingleton<AuthService>(() => AuthService(sl<AuthRepository>()));
  sl.registerLazySingleton<UserService>(() => UserService(sl<UserRepository>()));

  sl.registerFactory<AuthProvider>(() => AuthProvider(sl<AuthService>(), sl<TokenRepository>()));
}
