import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static final String baseApiUrl = dotenv.get(
    'BASE_API_URL',
    fallback: 'https://sistemadental-test-gwenfkc0fafabzcj.centralus-01.azurewebsites.net/api',
  );

  static const String loginEndpoint = '/Auth/login';
  static const String meEndpoint = '/Auth/me';
  static const String usersEndpoint = '/User';

  static const Duration timeoutDuration = Duration(seconds: 30);
}
