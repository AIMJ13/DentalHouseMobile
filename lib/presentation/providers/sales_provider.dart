import 'package:flutter/material.dart';
import '../../core/errors/app_exceptions.dart';
import '../../Data/models/sale_model.dart';
import '../../services/sales_service.dart';
import 'log_provider.dart' show ViewStatus;

class SalesProvider extends ChangeNotifier {
  final SalesService _service;

  SalesProvider(this._service);

  List<SaleModel> _sales = [];

  ViewStatus _viewStatus = ViewStatus.initial;
  String? _errorMessage;

  ViewStatus get viewStatus => _viewStatus;
  bool get isLoading => _viewStatus == ViewStatus.loading;
  String? get errorMessage => _errorMessage;

  List<SaleModel> get saleModels => _sales;

  List<Map<String, dynamic>> get sales =>
      _sales.map((item) => item.toJson()).toList();

  int get totalSales => _sales.length;

  double get totalRevenue => _sales.fold(
        0.0,
        (total, sale) => total + sale.totalAmount,
      );

  double get averageSale =>
      totalSales == 0 ? 0.0 : totalRevenue / totalSales;

  int get totalServicesSold => _sales.fold(
        0,
        (total, sale) => total + sale.servicesCount,
      );

  double get monthlyRevenue {
    final now = DateTime.now();

    return _sales.where((sale) {
      final date = _parseSaleDate(sale.saleDate);

      return date != null &&
          date.month == now.month &&
          date.year == now.year;
    }).fold(
      0.0,
      (total, sale) => total + sale.totalAmount,
    );
  }

  Map<String, dynamic>? get topDoctor {
    if (_sales.isEmpty) return null;

    final totals = <String, double>{};

    for (final sale in _sales) {
      final name = sale.doctorName.isNotEmpty ? sale.doctorName : 'Sin nombre';

      totals[name] = (totals[name] ?? 0.0) + sale.totalAmount;
    }

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'name': entries.first.key,
      'amount': entries.first.value,
      'percentage': totalRevenue == 0.0
          ? 0.0
          : entries.first.value / totalRevenue * 100,
    };
  }

  Map<String, dynamic>? get topService {
    final totals = <String, double>{};
    final quantities = <String, int>{};

    for (final sale in _sales) {
      for (final detail in sale.details) {
        final name = detail.serviceName.isNotEmpty ? detail.serviceName : 'Sin nombre';

        totals[name] = (totals[name] ?? 0.0) + detail.subTotal;
        quantities[name] = (quantities[name] ?? 0) + detail.quantity;
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

  DateTime? _parseSaleDate(String text) {
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
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
