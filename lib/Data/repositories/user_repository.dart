import '../../core/networks/api_client.dart';

class UserRepository {
  final ApiClient client;

  UserRepository(this.client);

  void callApiClient() => client.get();
}
