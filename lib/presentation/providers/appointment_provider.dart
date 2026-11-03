import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/appointment_model.dart';
import '../../services/appointment_service.dart';
import 'log_provider.dart' show ViewStatus;

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _service;

  AppointmentProvider(this._service);

  List<AppointmentModel> _citas = [];
  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;

  List<AppointmentModel> get citas => _citas;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  bool get hasError => _viewStatus == ViewStatus.error;
  String? get errorMessage => _errorMessage;

  int get total => _citas.length;

  int contarPorEstado(String estado) =>
      _citas.where((c) => c.estado == estado).length;

  List<String> get doctores {
    final nombres = _citas
        .map((c) => c.doctor)
        .where((d) => d.isNotEmpty)
        .toSet()
        .toList();
    nombres.sort();
    return nombres;
  }

  Future<void> fetchCitas() async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _citas = await _service.getAll();
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las citas';
      _viewStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> cambiarEstado(int id, String estado) async {
    String? error;
    try {
      await _service.updateStatus(id, estado);
    } on AppException catch (e) {
      error = e.message;
    } catch (_) {
      error = 'No se pudo cambiar el estado de la cita';
    }

    await fetchCitas();

    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }
    return true;
  }
}