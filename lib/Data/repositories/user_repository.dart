import '../../core/constant/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
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
   Future<UserModel> getProfile() async {
    final response = await client.get(ApiConstants.profileEndpoint);
    if (response is! Map<String, dynamic> || response['data'] is! Map<String, dynamic>) {
      throw const ParsingException('Formato de perfil no válido');
    }
    return UserModel.fromJson(response['data']);
  }

  Future<List<UserModel>> getUsers() async {
    final response = await client.get(
      ApiConstants.usersEndpoint,
      query: {'pageNumber': 1, 'pageSize': 100},
    );
    if (response is! Map<String, dynamic>) {
      throw const ParsingException('Formato de usuarios no válido');
    }
    final lista = response['data'];
    if (lista is! List) return [];
    return lista.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> setState(int id, bool state) async {
    await client.patch('${ApiConstants.usersEndpoint}/$id/state?state=$state');
  }
}
