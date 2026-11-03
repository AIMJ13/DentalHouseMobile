import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../data/models/log_model.dart';
import '../../services/log_service.dart';

enum ViewStatus { initial, loading, success, error }

class LogProvider extends ChangeNotifier {
  final LogService _service;

  LogProvider(this._service);

  List<LogModel> _logs = [];
  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;

  int _currentPage = 1;
  int _totalPages = 1;
  int _totalRecords = 0;
  final int _pageSize = 5;

  String _selectedModule = 'Todos los módulos';
  String _selectedAction = 'Todas las acciones';
  String _selectedStatus = 'Todos';
  String _searchTerm = '';

  List<LogModel> get logs => _logs;
  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalRecords => _totalRecords;
  int get pageSize => _pageSize;

  String get selectedModule => _selectedModule;
  String get selectedAction => _selectedAction;
  String get selectedStatus => _selectedStatus;
  String get searchTerm => _searchTerm;

  Future<void> fetchLogs({int? page, bool resetPage = false}) async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    if (resetPage) {
      _currentPage = 1;
    } else if (page != null) {
      _currentPage = page;
    }

    bool? isSuccess;
    if (_selectedStatus == 'Éxito' || _selectedStatus == 'Success') {
      isSuccess = true;
    } else if (_selectedStatus == 'Error') {
      isSuccess = false;
    }

    try {
      final paged = await _service.getAll(
        pageNumber: _currentPage,
        pageSize: _pageSize,
        module: _selectedModule,
        action: _selectedAction,
        searchTerm: _searchTerm.isNotEmpty ? _searchTerm : null,
        isSuccess: isSuccess,
      );

      _logs = paged.items;
      _currentPage = paged.pageNumber;
      _totalPages = paged.totalPages > 0 ? paged.totalPages : 1;
      _totalRecords = paged.totalRecords;
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los registros de auditoría';
      _viewStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  void setModule(String module) {
    if (_selectedModule == module) return;
    _selectedModule = module;
    fetchLogs(resetPage: true);
  }

  void setAction(String action) {
    if (_selectedAction == action) return;
    _selectedAction = action;
    fetchLogs(resetPage: true);
  }

  void setStatus(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    fetchLogs(resetPage: true);
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    fetchLogs(resetPage: true);
  }

  void clearFilters() {
    _selectedModule = 'Todos los módulos';
    _selectedAction = 'Todas las acciones';
    _selectedStatus = 'Todos';
    _searchTerm = '';
    fetchLogs(resetPage: true);
  }

  void changePage(int page) {
    if (page < 1 || page > _totalPages || page == _currentPage) return;
    fetchLogs(page: page);
  }
}
