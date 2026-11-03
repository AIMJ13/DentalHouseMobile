import 'sale_detail_model.dart';

class SaleModel {
  final int saleId;
  final String patientName;
  final String doctorName;
  final String? appointmentCode;
  final String saleDate;
  final double totalAmount;
  final int servicesCount;
  final List<SaleDetailModel> details;

  const SaleModel({
    required this.saleId,
    required this.patientName,
    required this.doctorName,
    this.appointmentCode,
    required this.saleDate,
    required this.totalAmount,
    this.servicesCount = 0,
    this.details = const [],
  });

  String get code => 'VTA-${saleId.toString().padLeft(3, '0')}';

  String get formattedTotal => 'C\$ ${totalAmount.toStringAsFixed(2)}';

  String get formattedDate {
    if (saleDate.isEmpty) return '';
    return saleDate.split('T').first.split(' ').first;
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final rawDetails = (json['details'] as List<dynamic>?) ?? [];

    final parsedDetails = rawDetails
        .map((item) => SaleDetailModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();

    return SaleModel(
      saleId: (json['saleId'] as num?)?.toInt() ?? (json['id'] as num?)?.toInt() ?? 0,
      patientName: json['patientName']?.toString() ?? 'Paciente no especificado',
      doctorName: json['doctorName']?.toString() ?? 'Doctor no especificado',
      appointmentCode: json['appointmentCode']?.toString() ?? json['appointmentId']?.toString(),
      saleDate: json['saleDate']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      servicesCount: (json['servicesCount'] as num?)?.toInt() ?? parsedDetails.length,
      details: parsedDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saleId': saleId,
      'patientName': patientName,
      'doctorName': doctorName,
      'appointmentCode': appointmentCode,
      'saleDate': saleDate,
      'totalAmount': totalAmount,
      'servicesCount': servicesCount,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}
