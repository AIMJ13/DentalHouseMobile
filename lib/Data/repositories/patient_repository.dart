import '../../core/constant/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/networks/api_client.dart';
import '../models/patient_model.dart';

class PatientRepository {
  final ApiClient client;

  PatientRepository(this.client);

  Future<List<PatientModel>> getPatients() async {
    final response = await client.get(
      ApiConstants.patientsEndpoint,
      query: {
        'pageNumber': 1,
        'pageSize': 100,
      },
    );

    if (response is! Map<String, dynamic>) {
      throw const ParsingException('Formato de pacientes no válido.');
    }

    final lista = response['data'];

    if (lista is! List) {
      throw const ParsingException(
        'La respuesta no contiene una lista válida de pacientes.',
      );
    }

    return lista
        .map(
          (item) => PatientModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<PatientModel> getById(int id) async {
    final response = await client.get('${ApiConstants.patientsEndpoint}/$id');

    if (response is! Map<String, dynamic>) {
      throw const ParsingException('Formato de paciente no válido.');
    }

    final data = response['data'] is Map ? response['data'] : response;
    return PatientModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> createPatient({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String birthDate,
    required bool state,
  }) async {
    await client.post(
      ApiConstants.patientsEndpoint,
      body: {
        'patientId': 0,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'address': address,
        'birthDate': birthDate,
        'state': state,
      },
    );
  }

  Future<void> updatePatient({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String birthDate,
    required bool state,
  }) async {
    await client.put(
      '${ApiConstants.patientsEndpoint}/$id',
      body: {
        'patientId': id,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'address': address,
        'birthDate': birthDate,
        'state': state,
      },
    );
  }

  Future<void> setState(int id, bool state) async {
    await client.patch(
      '${ApiConstants.patientsEndpoint}/$id/state?state=$state',
    );
  }
}
