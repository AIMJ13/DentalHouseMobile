import '../core/errors/app_exceptions.dart';
import '../data/models/patient_model.dart';
import '../data/repositories/patient_repository.dart';

class PatientService {
  final PatientRepository _repository;

  PatientService(this._repository);

  Future<List<PatientModel>> getAll() {
    return _repository.getPatients();
  }

  Future<PatientModel> getById(int id) {
    if (id <= 0) {
      throw const ValidationException('Identificador de paciente no válido.');
    }
    return _repository.getById(id);
  }

  Future<void> createPatient({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String birthDate,
    required bool state,
  }) async {
    final cleanNombre = firstName.trim();
    final cleanApellido = lastName.trim();

    if (cleanNombre.isEmpty) {
      throw const ValidationException('El nombre del paciente es requerido.');
    }

    if (cleanApellido.isEmpty) {
      throw const ValidationException('El apellido del paciente es requerido.');
    }

    await _repository.createPatient(
      firstName: cleanNombre,
      lastName: cleanApellido,
      phone: phone.trim(),
      address: address.trim(),
      birthDate: birthDate.trim(),
      state: state,
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
    if (id <= 0) {
      throw const ValidationException('Identificador de paciente no válido.');
    }

    final cleanNombre = firstName.trim();
    final cleanApellido = lastName.trim();

    if (cleanNombre.isEmpty) {
      throw const ValidationException('El nombre del paciente es requerido.');
    }

    if (cleanApellido.isEmpty) {
      throw const ValidationException('El apellido del paciente es requerido.');
    }

    await _repository.updatePatient(
      id: id,
      firstName: cleanNombre,
      lastName: cleanApellido,
      phone: phone.trim(),
      address: address.trim(),
      birthDate: birthDate.trim(),
      state: state,
    );
  }

  Future<void> setState(int id, bool state) {
    return _repository.setState(id, state);
  }
}
