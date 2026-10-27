import '../../core/constant/api_constants.dart';
import '../../core/networks/api_client.dart';
import '../models/user_model.dart';

class UserRepository {
  final ApiClient client;

  UserRepository(this.client);

  Future<dynamic> getAll() async {
    return await client.get(ApiConstants.usersEndpoint);
  }

  Future<UserModel> getById(int id) async {
    final data = await client.get('${ApiConstants.usersEndpoint}/$id');
    return UserModel.fromJson(data as Map<String, dynamic>);
  }
}
