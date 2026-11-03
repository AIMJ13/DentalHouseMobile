import '../../core/constant/api_constants.dart';
import '../../core/networks/api_client.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/log_model.dart';

class LogRepository {
  final ApiClient client;

  LogRepository(this.client);

  Future<LogPaginationModel> getAll({Map<String, dynamic>? query}) async {
    final response = await client.get(ApiConstants.logsEndpoint, query: query);
    if (response is! Map<String, dynamic> && response is! List) {
      throw const ParsingException('Formato de logs no valido');
    }
    return LogPaginationModel.fromJson(response);
  }

  Future<LogModel> getById(String id) async {
    final response = await client.get('${ApiConstants.logsEndpoint}/$id');
    if (response == null || response is! Map<String, dynamic>) {
      throw const NotFoundException('Log no encontrado');
    }
    return LogModel.fromJson(response);
  }
}
