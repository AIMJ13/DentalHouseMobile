import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/specialty_model.dart';
import '../../services/specialty_service.dart';
import 'log_provider.dart' show ViewStatus;

class SpecialtyProvider extends ChangeNotifier {
  final SpecialtyService _service;

  SpecialtyProvider(this._service);

  List<SpecialtyModel> _specialties = [];

  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;

  String _searchTerm = '';
  String _selectedFilter = 'Todos';

  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;

  String get selectedFilter => _selectedFilter;
  String get searchTerm => _searchTerm;

  List<SpecialtyModel> get specialties {
    final query = _searchTerm.trim().toLowerCase();

    return _specialties.where((specialty) {
      final name = specialty.specialtyName.toLowerCase();
      final code = specialty.code.toLowerCase();
      final id = specialty.specialtyId.toString();

      final matchesSearch =
          query.isEmpty || name.contains(query) || code.contains(query) || id.contains(query);

      if (!matchesSearch) return false;

      if (_selectedFilter == 'Activas' && !specialty.state) {
        return false;
      }

      if (_selectedFilter == 'Inactivas' && specialty.state) {
        return false;
      }

      return true;
    }).toList();
  }

  int get totalSpecialties => _specialties.length;

  int get totalActive =>
      _specialties.where((specialty) => specialty.state).length;

  int get totalInactive =>
      _specialties.where((specialty) => !specialty.state).length;

  Future<void> fetchSpecialties() async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _specialties = await _service.getAll();
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las especialidades';
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

  Future<bool> createSpecialty({
    required String specialtyName,
    required bool state,
  }) async {
    _errorMessage = null;
    try {
      await _service.createSpecialty(
        specialtyName: specialtyName,
        state: state,
      );
      await fetchSpecialties();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error inesperado al crear la especialidad';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSpecialty({
    required int id,
    required String specialtyName,
    required bool state,
    required bool previousState,
  }) async {
    _errorMessage = null;
    try {
      await _service.updateSpecialty(
        id: id,
        specialtyName: specialtyName,
        state: previousState,
      );

      if (state != previousState) {
        await _service.setState(id, state);
      }

      await fetchSpecialties();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error inesperado al actualizar la especialidad';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleState(int id, bool state) async {
    _errorMessage = null;
    try {
      await _service.setState(id, state);
      await fetchSpecialties();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al cambiar el estado de la especialidad';
      notifyListeners();
      return false;
    }
  }
}
