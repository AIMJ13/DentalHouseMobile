
import '../../core/networks/api_client.dart';

class SalesRepository {
  final ApiClient _apiClient;

  SalesRepository(this._apiClient);

  Future<Map<String, dynamic>> getSales({
    int pageNumber = 1,
    int pageSize = 100,
  }) async {
    final response = await _apiClient.get(
      '/Sales',
      query: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    if (response is! Map) {
      throw const FormatException(
        'La respuesta de ventas no tiene el formato esperado.',
      );
    }

    final result = Map<String, dynamic>.from(response);

    if (result['data'] is! List) {
      throw const FormatException(
        'La respuesta de ventas no contiene una lista válida.',
      );
    }

    return result;
  }
}
