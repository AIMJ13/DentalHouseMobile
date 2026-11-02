import '../core/errors/app_exceptions.dart';
import '../data/models/appointment_model.dart';
import '../data/repositories/appointment_repository.dart';

class AppointmentService {
  final AppointmentRepository repo;

  AppointmentService(this.repo);

  Future<List<AppointmentModel>> getAll() async {
    return await repo.getAll();
  }

  Future<void> updateStatus(int id, String estado) async {
    if (id <= 0) {
      throw const ValidationException('Cita no válida');
    }
    await repo.updateStatus(id, _estadoParaApi(estado));
  }

  String _estadoParaApi(String estado) {
    switch (estado) {
      case 'Completada':
        return 'Completada';
      case 'Cancelada':
        return 'Cancelada';
      case 'No asistió':
        return 'NoAsistio';
      default:
        return 'Programada';
    }
  }
}