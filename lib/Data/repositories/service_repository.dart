import '../../core/constant/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/networks/api_client.dart';
import '../models/service_model.dart';

class ServiceRepository {
  final ApiClient client;

  ServiceRepository(this.client);

  Future<List<ServiceModel>> getServices() async {
    final response = await client.get(
      ApiConstants.servicesEndpoint,
      query: {
        'pageNumber': 1,
        'pageSize': 100,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const ParsingException(
        'Formato de servicios no válido.',
      );
    }

    final lista = response['data'];

    if (lista is! List) {
      throw const ParsingException(
        'La respuesta no contiene una lista válida de servicios.',
      );
    }

    return lista
        .map(
          (item) => ServiceModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<ServiceModel> getById(int id) async {
    final response = await client.get(
      '${ApiConstants.servicesEndpoint}/$id',
    );

    if (response is! Map<String, dynamic>) {
      throw const ParsingException(
        'Formato de servicio no válido.',
      );
    }

    return ServiceModel.fromJson(response);
  }

  Future<void> createService({
    required String serviceName,
    required String cost,
    required bool state,
  }) async {
    await client.post(
      ApiConstants.servicesEndpoint,
      body: {
        'serviceId': 0,
        'serviceName': serviceName,
        'cost': cost,
        'state': state,
      },
    );
  }

  Future<void> updateService({
    required int id,
    required String serviceName,
    required String cost,
    required bool state,
  }) async {
    await client.put(
      '${ApiConstants.servicesEndpoint}/$id',
      body: {
        'serviceId': id,
        'serviceName': serviceName,
        'cost': cost,
        'state': state,
      },
    );
  }

  Future<void> setState(int id, bool state) async {
    await client.patch(
      '${ApiConstants.servicesEndpoint}/$id/state?state=$state',
    );
  }
}
