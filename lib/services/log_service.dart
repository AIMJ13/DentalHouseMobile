import '../core/errors/app_exceptions.dart';
import '../data/models/log_model.dart';
import '../data/repositories/log_repository.dart';

class LogService {
  final LogRepository repository;

  LogService(this.repository);

  Future<LogPaginationModel> getAll({
    int pageNumber = 1,
    int pageSize = 10,
    String? module,
    String? action,
    String? level,
    String? userId,
    String? searchTerm,
    bool? isSuccess,
  }) async {
    if (pageNumber < 1) {
      throw const ValidationException('El número de página debe ser mayor a 0');
    }

    if (pageSize < 1 || pageSize > 100) {
      throw const ValidationException('El tamaño de página debe estar entre 1 y 100');
    }

    final Map<String, dynamic> query = {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    if (module != null && module.trim().isNotEmpty && module != 'All' && !module.toLowerCase().startsWith('todo')) {
      query['module'] = module.trim();
    }
    if (action != null && action.trim().isNotEmpty && action != 'All' && !action.toLowerCase().startsWith('toda')) {
      query['action'] = action.trim();
    }
    if (level != null && level.trim().isNotEmpty && level != 'All' && !level.toLowerCase().startsWith('todo')) {
      query['level'] = level.trim();
    }
    if (userId != null && userId.trim().isNotEmpty) {
      query['userName'] = userId.trim();
    }
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      query['searchTerm'] = searchTerm.trim();
    }
    if (isSuccess != null) {
      query['isSuccess'] = isSuccess.toString();
    }

    return await repository.getAll(query: query);
  }

  Future<LogModel> getById(String id) async {
    final cleanId = id.trim();
    if (cleanId.isEmpty) {
      throw const ValidationException('El identificador del log no puede estar vacío');
    }
    return await repository.getById(cleanId);
  }
}
