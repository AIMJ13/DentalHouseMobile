import '../data/models/sale_model.dart';
import '../data/repositories/sales_repository.dart';

class SalesService {
  final SalesRepository _repository;

  SalesService(this._repository);

  Future<List<SaleModel>> getAllSales() async {
    return await _repository.getSales();
  }

  Future<SaleModel> getSaleById(int id) async {
    return await _repository.getSaleById(id);
  }
}
