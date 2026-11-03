import '../../core/constant/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/networks/api_client.dart';
import '../models/specialty_model.dart';

class SpecialtyRepository {
  final ApiClient client;

  SpecialtyRepository(this.client);

  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await client.get(
      ApiConstants.specialtiesEndpoint,
      query: {
        'pageNumber': 1,
        'pageSize': 100,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const ParsingException(
        'Formato de especialidades no válido.',
      );
    }

    final lista = response['data'];

    if (lista is! List) {
      throw const ParsingException(
        'La respuesta no contiene una lista válida de especialidades.',
      );
    }

    return lista
        .map(
          (item) => SpecialtyModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<SpecialtyModel> getById(int id) async {
    final response = await client.get(
      '${ApiConstants.specialtiesEndpoint}/$id',
    );

    if (response is! Map<String, dynamic>) {
      throw const ParsingException(
        'Formato de especialidad no válido.',
      );
    }

    final data = response['data'] is Map ? response['data'] : response;
    return SpecialtyModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> createSpecialty({
    required String specialtyName,
    required bool state,
  }) async {
    await client.post(
      ApiConstants.specialtiesEndpoint,
      body: {
        'specialtyName': specialtyName,
        'state': state,
      },
    );
  }

  Future<void> updateSpecialty({
    required int id,
    required String specialtyName,
    required bool state,
  }) async {
    await client.put(
      '${ApiConstants.specialtiesEndpoint}/$id',
      body: {
        'specialtyId': id,
        'specialtyName': specialtyName,
        'state': state,
      },
    );
  }

  Future<void> setState(int id, bool state) async {
    await client.patch(
      '${ApiConstants.specialtiesEndpoint}/$id/state?state=$state',
    );
  }
}
