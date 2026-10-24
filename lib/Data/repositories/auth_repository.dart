import '../../core/constant/api_constants.dart';
import '../../core/networks/api_client.dart';
import '../models/token_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<TokenModel> login(String userName, String password) async {
    final data = await _apiClient.post(
      ApiConstants.loginEndpoint,
      body: {
        'userName': userName,
        'password': password,
      },
    );
    return TokenModel.fromJson(data as Map<String, dynamic>);
  }
}
