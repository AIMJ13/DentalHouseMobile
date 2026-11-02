class SaleDetailModel {
  final String serviceName;
  final int quantity;
  final double subTotal;

  const SaleDetailModel({
    required this.serviceName,
    required this.quantity,
    required this.subTotal,
  });

  String get formattedSubTotal => 'C\$ ${subTotal.toStringAsFixed(2)}';

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      serviceName: json['serviceName']?.toString() ?? 'Servicio',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceName': serviceName,
      'quantity': quantity,
      'subTotal': subTotal,
    };
  }
}
