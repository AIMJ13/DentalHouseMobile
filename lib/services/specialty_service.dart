import '../core/errors/app_exceptions.dart';
import '../data/models/specialty_model.dart';
import '../data/repositories/specialty_repository.dart';

class SpecialtyService {
  final SpecialtyRepository _repository;

  SpecialtyService(this._repository);

  String _validarNombre(String specialtyName) {
    final nombre = specialtyName.trim();

    if (nombre.isEmpty) {
      throw const ValidationException(
        'El nombre de la especialidad es requerido.',
      );
    }

    final cantidadLetras = RegExp(
      r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]',
    ).allMatches(nombre).length;

    if (cantidadLetras < 5) {
      throw const ValidationException(
        'El nombre de la especialidad debe contener al menos 5 letras.',
      );
    }

    return nombre;
  }

  Future<List<SpecialtyModel>> getAll() {
    return _repository.getSpecialties();
  }

  Future<SpecialtyModel> getById(int id) {
    if (id <= 0) {
      throw const ValidationException(
        'Identificador de especialidad no válido.',
      );
    }
    return _repository.getById(id);
  }

  Future<void> createSpecialty({
    required String specialtyName,
    required bool state,
  }) async {
    final nombreValidado = _validarNombre(specialtyName);

    await _repository.createSpecialty(
      specialtyName: nombreValidado,
      state: state,
    );
  }

  Future<void> updateSpecialty({
    required int id,
    required String specialtyName,
    required bool state,
  }) async {
    if (id <= 0) {
      throw const ValidationException(
        'Identificador de especialidad no válido.',
      );
    }

    final nombreValidado = _validarNombre(specialtyName);

    await _repository.updateSpecialty(
      id: id,
      specialtyName: nombreValidado,
      state: state,
    );
  }

  Future<void> setState(int id, bool state) {
    if (id <= 0) {
      throw const ValidationException(
        'Identificador de especialidad no válido.',
      );
    }
    return _repository.setState(id, state);
  }
}
