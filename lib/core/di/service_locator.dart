import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networks/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/log_repository.dart';
import '../../data/repositories/token_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/auth_service.dart';
import '../../services/log_service.dart';
import '../../services/user_service.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/log_provider.dart';
import '../../data/repositories/sales_repository.dart';
import '../../services/sales_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerLazySingleton<TokenRepository>(() => TokenRepository(sl<SharedPreferences>()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(tokenRepository: sl<TokenRepository>()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<ApiClient>()));
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl<ApiClient>()));
  sl.registerLazySingleton<LogRepository>(() => LogRepository(sl<ApiClient>()));

  sl.registerLazySingleton<AuthService>(() => AuthService(sl<AuthRepository>()));
  sl.registerLazySingleton<UserService>(() => UserService(sl<UserRepository>()));
  sl.registerLazySingleton<LogService>(() => LogService(sl<LogRepository>()));

  sl.registerFactory<AuthProvider>(() => AuthProvider(sl<AuthService>(), sl<TokenRepository>()));
  sl.registerFactory<LogProvider>(() => LogProvider(sl<LogService>()));

  sl.registerLazySingleton<SalesRepository>(
  () => SalesRepository(sl<ApiClient>()));

sl.registerLazySingleton<SalesService>(
  () => SalesService(sl<SalesRepository>()));
}
