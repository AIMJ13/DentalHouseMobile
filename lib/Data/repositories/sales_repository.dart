import '../../core/constant/api_constants.dart';
import '../../core/networks/api_client.dart';
import '../models/sale_model.dart';

class SalesRepository {
  final ApiClient _apiClient;

  SalesRepository(this._apiClient);

  Future<List<SaleModel>> getSales({
    int pageNumber = 1,
    int pageSize = 100,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.salesEndpoint,
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

    final list = result['data'] as List;

    return list
        .map((item) => SaleModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }

  Future<SaleModel> getSaleById(int id) async {
    final response = await _apiClient.get('${ApiConstants.salesEndpoint}/$id');

    if (response is! Map) {
      throw const FormatException(
        'La respuesta de la venta no tiene el formato esperado.',
      );
    }

    return SaleModel.fromJson(Map<String, dynamic>.from(response));
  }
}
