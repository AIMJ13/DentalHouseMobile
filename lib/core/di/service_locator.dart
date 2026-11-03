import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../networks/api_client.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/log_repository.dart';
import '../../data/repositories/patient_repository.dart';
import '../../data/repositories/sales_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/token_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/appointment_service.dart';
import '../../services/auth_service.dart';
import '../../services/doctor_service.dart';
import '../../services/log_service.dart';
import '../../services/patient_service.dart';
import '../../services/sales_service.dart';
import '../../services/service_service.dart';
import '../../services/user_service.dart';
import '../../presentation/providers/appointment_provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/doctor_provider.dart';
import '../../presentation/providers/log_provider.dart';
import '../../presentation/providers/patient_provider.dart';
import '../../presentation/providers/sales_provider.dart';
import '../../presentation/providers/service_provider.dart';
import '../../presentation/providers/user_provider.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerLazySingleton<TokenRepository>(() => TokenRepository(sl<SharedPreferences>()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(tokenRepository: sl<TokenRepository>()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<ApiClient>()));
  sl.registerLazySingleton<DoctorRepository>(() => DoctorRepository(sl<ApiClient>()));
  sl.registerLazySingleton<UserRepository>(() => UserRepository(sl<ApiClient>()));
  sl.registerLazySingleton<LogRepository>(() => LogRepository(sl<ApiClient>()));
  sl.registerLazySingleton<PatientRepository>(() => PatientRepository(sl<ApiClient>()));
  sl.registerLazySingleton<ServiceRepository>(() => ServiceRepository(sl<ApiClient>()));
  sl.registerLazySingleton<SalesRepository>(() => SalesRepository(sl<ApiClient>()));
  sl.registerLazySingleton<AppointmentRepository>(() => AppointmentRepository(sl<ApiClient>()));

  sl.registerLazySingleton<AuthService>(() => AuthService(sl<AuthRepository>()));
  sl.registerLazySingleton<DoctorService>(() => DoctorService(sl<DoctorRepository>()));
  sl.registerLazySingleton<UserService>(() => UserService(sl<UserRepository>()));
  sl.registerLazySingleton<LogService>(() => LogService(sl<LogRepository>()));
  sl.registerLazySingleton<PatientService>(() => PatientService(sl<PatientRepository>()));
  sl.registerLazySingleton<ServiceService>(() => ServiceService(sl<ServiceRepository>()));
  sl.registerLazySingleton<SalesService>(() => SalesService(sl<SalesRepository>()));
  sl.registerLazySingleton<AppointmentService>(() => AppointmentService(sl<AppointmentRepository>()));

  sl.registerFactory<AuthProvider>(() => AuthProvider(sl<AuthService>(), sl<TokenRepository>()));
  sl.registerFactory<DoctorProvider>(() => DoctorProvider(sl<DoctorService>()));
  sl.registerFactory<LogProvider>(() => LogProvider(sl<LogService>()));
  sl.registerFactory<PatientProvider>(() => PatientProvider(sl<PatientService>()));
  sl.registerFactory<UserProvider>(() => UserProvider(sl<UserService>()));
  sl.registerFactory<ServiceProvider>(() => ServiceProvider(sl<ServiceService>()));
  sl.registerFactory<SalesProvider>(() => SalesProvider(sl<SalesService>()));
  sl.registerFactory<AppointmentProvider>(() => AppointmentProvider(sl<AppointmentService>()));
}
