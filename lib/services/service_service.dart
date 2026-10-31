import '../data/models/service_model.dart';
import '../data/repositories/service_repository.dart';

class ServiceService {
  final ServiceRepository _repository;

  ServiceService(this._repository);

  Future<List<ServiceModel>> getServices() {
    return _repository.getServices();
  }

  Future<ServiceModel> getById(int id) {
    return _repository.getById(id);
  }

  Future<void> createService({
    required String serviceName,
    required String cost,
    required bool state,
  }) {
    return _repository.createService(
      serviceName: serviceName,
      cost: cost,
      state: state,
    );
  }

  Future<void> updateService({
    required int id,
    required String serviceName,
    required String cost,
    required bool state,
  }) {
    return _repository.updateService(
      id: id,
      serviceName: serviceName,
      cost: cost,
      state: state,
    );
  }

  Future<void> setState(int id, bool state) {
    return _repository.setState(id, state);
  }
}
