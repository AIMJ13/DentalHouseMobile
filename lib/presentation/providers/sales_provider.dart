import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../services/sales_service.dart';
import 'log_provider.dart' show ViewStatus;

class SalesProvider extends ChangeNotifier {
  final SalesService _service;

  SalesProvider(this._service);

  List<Map<String, dynamic>> _sales = [];

  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;

  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;

  List<Map<String, dynamic>> get sales => _sales;

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int get totalSales => _sales.length;

  double get totalRevenue => _sales.fold(
        0,
        (total, sale) => total + _toDouble(sale['totalAmount']),
      );

  double get averageSale =>
      totalSales == 0 ? 0 : totalRevenue / totalSales;

  int get totalServicesSold => _sales.fold(
        0,
        (total, sale) => total + _toInt(sale['servicesCount']),
      );

  double get monthlyRevenue {
    final now = DateTime.now();

    return _sales.where((sale) {
      final date = _parseSaleDate(sale['saleDate']);

      return date != null &&
          date.month == now.month &&
          date.year == now.year;
    }).fold(
      0,
      (total, sale) => total + _toDouble(sale['totalAmount']),
    );
  }

  Map<String, dynamic>? get topDoctor {
    if (_sales.isEmpty) return null;

    final totals = <String, double>{};

    for (final sale in _sales) {
      final name = sale['doctorName']?.toString() ?? 'Sin nombre';

      totals[name] =
          (totals[name] ?? 0) + _toDouble(sale['totalAmount']);
    }

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'name': entries.first.key,
      'amount': entries.first.value,
      'percentage': totalRevenue == 0
          ? 0.0
          : entries.first.value / totalRevenue * 100,
    };
  }

  Map<String, dynamic>? get topService {
    final totals = <String, double>{};
    final quantities = <String, int>{};

    for (final sale in _sales) {
      final details = sale['details'];

      if (details is! List) continue;

      for (final detail in details) {
        if (detail is! Map) continue;

        final name =
            detail['serviceName']?.toString() ?? 'Sin nombre';

        totals[name] =
            (totals[name] ?? 0) + _toDouble(detail['subTotal']);

        quantities[name] =
            (quantities[name] ?? 0) + _toInt(detail['quantity']);
      }
    }

    if (totals.isEmpty) return null;

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final name = entries.first.key;

    return {
      'name': name,
      'amount': entries.first.value,
      'quantity': quantities[name] ?? 0,
    };
  }

  DateTime? _parseSaleDate(dynamic value) {
    if (value == null) return null;

    final text = value.toString();

    final parsed = DateTime.tryParse(text);
    if (parsed != null) return parsed;

    final parts = text.split(' ').first.split('/');

    if (parts.length != 3) return null;

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || day == null || year == null) {
      return null;
    }

    return DateTime.tryParse(
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}',
    );
  }

  Future<void> fetchSales() async {
    _viewStatus = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _sales = await _service.getAllSales();
      _viewStatus = ViewStatus.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _viewStatus = ViewStatus.error;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las ventas';
      _viewStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
