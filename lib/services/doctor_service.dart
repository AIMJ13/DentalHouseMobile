import '../core/errors/app_exceptions.dart';
import '../data/models/doctor_model.dart';
import '../data/repositories/doctor_repository.dart';

class DoctorService {
  final DoctorRepository _repository;

  DoctorService(this._repository);

  Future<List<DoctorModel>> getAll() {
    return _repository.getAll();
  }

  Future<DoctorModel> getById(int id) {
    if (id <= 0) {
      throw const ValidationException('Identificador de doctor no válido.');
    }
    return _repository.getById(id);
  }

  Future<void> create({
    required String firstName,
    required String lastName,
    String? phone,
    String? specialtyName,
    int? specialtyId,
    bool state = true,
  }) async {
    final cleanNombre = firstName.trim();
    final cleanApellido = lastName.trim();

    if (cleanNombre.isEmpty) {
      throw const ValidationException('El nombre del doctor es requerido.');
    }

    if (cleanApellido.isEmpty) {
      throw const ValidationException('El apellido del doctor es requerido.');
    }

    final doctor = DoctorModel(
      id: 0,
      firstName: cleanNombre,
      lastName: cleanApellido,
      phone: phone?.trim(),
      specialtyName: specialtyName?.trim(),
      specialtyIds: specialtyId != null ? [specialtyId] : const [],
      isActive: state,
    );

    await _repository.create(doctor, specialtyId: specialtyId);
  }

  Future<void> update({
    required int id,
    required String firstName,
    required String lastName,
    String? phone,
    String? specialtyName,
    int? specialtyId,
    bool state = true,
  }) async {
    if (id <= 0) {
      throw const ValidationException('Identificador de doctor no válido.');
    }

    final cleanNombre = firstName.trim();
    final cleanApellido = lastName.trim();

    if (cleanNombre.isEmpty) {
      throw const ValidationException('El nombre del doctor es requerido.');
    }

    if (cleanApellido.isEmpty) {
      throw const ValidationException('El apellido del doctor es requerido.');
    }

    final doctor = DoctorModel(
      id: id,
      firstName: cleanNombre,
      lastName: cleanApellido,
      phone: phone?.trim(),
      specialtyName: specialtyName?.trim(),
      specialtyIds: specialtyId != null ? [specialtyId] : const [],
      isActive: state,
    );

    await _repository.update(doctor, specialtyId: specialtyId);
  }

  Future<void> setState(int id, bool state) {
    if (id <= 0) {
      throw const ValidationException('Identificador de doctor no válido.');
    }
    return _repository.setState(id, state);
  }
}
