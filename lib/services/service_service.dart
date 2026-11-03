import '../core/errors/app_exceptions.dart';
import '../data/models/service_model.dart';
import '../data/repositories/service_repository.dart';

class ServiceService {
  final ServiceRepository _repository;

  ServiceService(this._repository);

  String _validarNombre(String serviceName) {
    final nombre = serviceName.trim();

    final cantidadLetras = RegExp(
      r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]',
    ).allMatches(nombre).length;

    if (cantidadLetras < 5) {
      throw const ValidationException(
        'El nombre del servicio debe contener al menos 5 letras.',
      );
    }

    return nombre;
  }

  Future<List<ServiceModel>> getAll() {
    return _repository.getServices();
  }

  Future<ServiceModel> getById(int id) {
    return _repository.getById(id);
  }

  Future<void> createService({
    required String serviceName,
    required String cost,
    required bool state,
  }) async {
    final nombreValidado = _validarNombre(serviceName);

    await _repository.createService(
      serviceName: nombreValidado,
      cost: cost.trim(),
      state: state,
    );
  }

  Future<void> updateService({
    required int id,
    required String serviceName,
    required String cost,
    required bool state,
  }) async {
    final nombreValidado = _validarNombre(serviceName);

    await _repository.updateService(
      id: id,
      serviceName: nombreValidado,
      cost: cost.trim(),
      state: state,
    );
  }

  Future<void> setState(int id, bool state) {
    return _repository.setState(id, state);
  }
}