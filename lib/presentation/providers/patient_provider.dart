import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/patient_model.dart';
import '../../services/patient_service.dart';
import 'log_provider.dart' show ViewStatus;

class PatientProvider extends ChangeNotifier {
  final PatientService _service;

  PatientProvider(this._service);

  List<PatientModel> _patients = [];
  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;
  String _searchTerm = '';

  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;
  String get searchTerm => _searchTerm;

  List<PatientModel> get patients {
    final query = _searchTerm.trim().toLowerCase();
    if (query.isEmpty) return _patients;

    return _patients.where((p) {
      final nombre = p.fullName.toLowerCase();
      final idStr = p.code.toLowerCase();
      final idNum = p.id.toString();
      final phone = p.phone.toLowerCase();
      final address = p.address.toLowerCase();

      return nombre.contains(query) ||
          idStr.contains(query) ||
          idNum.contains(query) ||
          phone.contains(query) ||
          address.contains(query);
    }).toList();
  }

  int get totalCount => _patients.length;
  int get activeCount => _patients.where((p) => p.isActive).length;
  int get inactiveCount => _patients.where((p) => !p.isActive).length;

  Future<void> fetchPatients() async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _patients = await _service.getAll();
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los pacientes';
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

  Future<bool> createPatient({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String birthDate,
    required bool state,
  }) async {
    _errorMessage = null;
    try {
      await _service.createPatient(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        birthDate: birthDate,
        state: state,
      );
      await fetchPatients();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error inesperado al registrar el paciente';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePatient({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String birthDate,
    required bool state,
    bool? previousState,
  }) async {
    _errorMessage = null;
    try {
      await _service.updatePatient(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        birthDate: birthDate,
        state: state,
      );

      if (previousState == null || state != previousState) {
        await _service.setState(id, state);
      }

      await fetchPatients();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error inesperado al actualizar el paciente';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleState(int id, bool state) async {
    _errorMessage = null;
    try {
      await _service.setState(id, state);
      await fetchPatients();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al cambiar el estado del paciente';
      notifyListeners();
      return false;
    }
  }
}
