import '../../core/constant/api_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/networks/api_client.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final ApiClient client;

  AppointmentRepository(this.client);

  Future<List<AppointmentModel>> getAll() async {
    final response = await client.get(
      ApiConstants.appointmentsEndpoint,
      query: {'pageNumber': 1, 'pageSize': 100},
    );
    if (response is! Map<String, dynamic>) {
      throw const ParsingException('Formato de citas no válido');
    }
    final lista = response['data'];
    if (lista is! List) return [];
    return lista.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> updateStatus(int id, String estadoApi) async {
    await client.patch('${ApiConstants.appointmentsEndpoint}/$id/status?status=$estadoApi');
  }
}