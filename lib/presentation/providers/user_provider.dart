import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/user_model.dart';
import '../../services/user_service.dart';
import 'log_provider.dart' show ViewStatus;

class UserProvider extends ChangeNotifier {
  final UserService _service;

  UserProvider(this._service);

  List<UserModel> _users = [];
  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;
  String _searchTerm = '';
  String _roleFilter = 'Todos';

  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;
  String get roleFilter => _roleFilter;

  List<UserModel> get users {
    final query = _searchTerm.trim().toLowerCase();
    final rolBuscado = _rolBuscado();

    return _users.where((u) {
      if (rolBuscado != null && !u.roles.contains(rolBuscado)) return false;
      if (query.isEmpty) return true;
      return u.userName.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query);
    }).toList();
  }

  String? _rolBuscado() {
    if (_roleFilter == 'Doctores') return 'Doctor';
    if (_roleFilter == 'Recepcionistas') return 'Recepcionista';
    if (_roleFilter == 'Administradores') return 'Administrador';
    return null;
  }

  Future<void> fetchUsers() async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _service.getUsers();
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los usuarios';
      _viewStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> setUserState(int id, bool state) async {
    try {
      await _service.setState(id, state);
      await fetchUsers();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo cambiar el estado del usuario';
      notifyListeners();
      return false;
    }
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void setRoleFilter(String filtro) {
    _roleFilter = filtro;
    notifyListeners();
  }
}