import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/service_model.dart';
import '../../services/service_service.dart';
import 'log_provider.dart' show ViewStatus;

class ServiceProvider extends ChangeNotifier {
  final ServiceService _service;

  ServiceProvider(this._service);

  List<ServiceModel> _services = [];

  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;

  String _searchTerm = '';
  String _selectedFilter = 'Todos';

  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;

  String get selectedFilter => _selectedFilter;
  String get searchTerm => _searchTerm;

  List<ServiceModel> get services {
    final query = _searchTerm.trim().toLowerCase();

    return _services.where((service) {
      final name = service.serviceName.toLowerCase();
      final id = service.serviceId.toString();

      final matchesSearch =
          query.isEmpty || name.contains(query) || id.contains(query);

      if (!matchesSearch) return false;

      if (_selectedFilter == 'Activos' && !service.state) {
        return false;
      }

      if (_selectedFilter == 'Inactivos' && service.state) {
        return false;
      }

      return true;
    }).toList();
  }

  int get totalServices => _services.length;

  int get totalActive =>
      _services.where((service) => service.state).length;

  int get totalInactive =>
      _services.where((service) => !service.state).length;

  Future<void> fetchServices() async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _services = await _service.getAll();
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los servicios';
      _viewStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void setFilter(String filter) {
    if (_selectedFilter == filter) return;

    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> createService({
    required String serviceName,
    required String cost,
    required bool state,
  }) async {
    await _service.createService(
      serviceName: serviceName,
      cost: cost,
      state: state,
    );

    await fetchServices();
  }

  Future<void> updateService({
    required int id,
    required String serviceName,
    required String cost,
    required bool state,
    required bool previousState,
  }) async {
    await _service.updateService(
      id: id,
      serviceName: serviceName,
      cost: cost,
      state: previousState,
    );

    if (state != previousState) {
      await _service.setState(id, state);
    }

    await fetchServices();
  }
}