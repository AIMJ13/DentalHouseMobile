import '../../core/constant/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/networks/api_client.dart';
import '../models/doctor_model.dart';

class DoctorRepository {
  final ApiClient client;

  DoctorRepository(this.client);

  Future<List<DoctorModel>> getAll({
    int pageNumber = 1,
    int pageSize = 100,
  }) async {
    final response = await client.get(
      ApiConstants.doctorsEndpoint,
      query: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const ParsingException('Formato de doctores no válido.');
    }

    final lista = response['data'];

    if (lista is! List) {
      throw const ParsingException(
        'La respuesta no contiene una lista válida de doctores.',
      );
    }

    return lista
        .map(
          (item) => DoctorModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<DoctorModel> getById(int id) async {
    final response = await client.get('${ApiConstants.doctorsEndpoint}/$id');

    if (response is! Map<String, dynamic>) {
      throw const ParsingException('Formato de doctor no válido.');
    }

    final data = response['data'] is Map ? response['data'] : response;
    return DoctorModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> create(DoctorModel doctor, {int? specialtyId}) async {
    await client.post(
      ApiConstants.doctorsEndpoint,
      body: doctor.toCreateJson(defaultSpecialtyId: specialtyId),
    );
  }

  Future<void> update(DoctorModel doctor, {int? specialtyId}) async {
    await client.put(
      '${ApiConstants.doctorsEndpoint}/${doctor.id}',
      body: doctor.toUpdateJson(defaultSpecialtyId: specialtyId),
    );
  }

  Future<void> setState(int id, bool state) async {
    await client.patch(
      '${ApiConstants.doctorsEndpoint}/$id/state?state=$state',
    );
  }
}
