import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/doctor_model.dart';
import '../../services/doctor_service.dart';
import 'log_provider.dart' show ViewStatus;

class DoctorProvider extends ChangeNotifier {
  final DoctorService _service;

  DoctorProvider(this._service);

  List<DoctorModel> _doctors = [];
  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;
  String _searchTerm = '';
  String _filter = 'Todos';

  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;
  String get searchTerm => _searchTerm;
  String get filter => _filter;

  List<DoctorModel> get doctors {
    final query = _searchTerm.trim().toLowerCase();
    return _doctors.where((d) {
      if (_filter == 'Activos' && !d.isActive) return false;
      if (_filter == 'Inactivos' && d.isActive) return false;
      if (query.isEmpty) return true;

      final nombre = d.fullName.toLowerCase();
      final codigo = d.code.toLowerCase();
      final idStr = d.id.toString();
      final especialidad = d.specialtyDisplay.toLowerCase();
      final telefono = (d.phone ?? '').toLowerCase();

      return nombre.contains(query) ||
          codigo.contains(query) ||
          idStr.contains(query) ||
          especialidad.contains(query) ||
          telefono.contains(query);
    }).toList();
  }

  int get totalCount => _doctors.length;
  int get activeCount => _doctors.where((d) => d.isActive).length;
  int get inactiveCount => _doctors.where((d) => !d.isActive).length;

  Future<void> fetchDoctors() async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _doctors = await _service.getAll();
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los doctores';
      _viewStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void clearSearch() {
    _searchTerm = '';
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<bool> createDoctor({
    required String firstName,
    required String lastName,
    String? phone,
    String? specialtyName,
    int? specialtyId,
    bool state = true,
  }) async {
    _errorMessage = null;
    try {
      await _service.create(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        specialtyName: specialtyName,
        specialtyId: specialtyId,
        state: state,
      );
      await fetchDoctors();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error inesperado al registrar el doctor';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDoctor({
    required int id,
    required String firstName,
    required String lastName,
    String? phone,
    String? specialtyName,
    int? specialtyId,
    bool state = true,
  }) async {
    _errorMessage = null;
    try {
      await _service.update(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        specialtyName: specialtyName,
        specialtyId: specialtyId,
        state: state,
      );
      await fetchDoctors();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error inesperado al actualizar el doctor';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleState(int id, bool state) async {
    _errorMessage = null;
    try {
      await _service.setState(id, state);
      await fetchDoctors();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al cambiar el estado del doctor';
      notifyListeners();
      return false;
    }
  }
}
