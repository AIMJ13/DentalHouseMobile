import '../Data/models/sale_model.dart';
import '../data/repositories/sales_repository.dart';

class SalesService {
  final SalesRepository _repository;

  SalesService(this._repository);

  Future<List<SaleModel>> getAllSales() async {
    final sales = <SaleModel>[];

    var pageNumber = 1;
    var totalPages = 1;

    do {
      final response = await _repository.getSales(
        pageNumber: pageNumber,
        pageSize: 100,
      );

      final data = response['data'] as List;

      sales.addAll(
        data.map(
          (item) => SaleModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        ),
      );

      totalPages = (response['totalPages'] as num?)?.toInt() ?? 1;
      pageNumber++;
    } while (pageNumber <= totalPages);

    return sales;
  }

  Future<SaleModel> getSaleById(int id) async {
    final response = await _repository.getSaleById(id);
    return SaleModel.fromJson(response);
  }
}
