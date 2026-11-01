class ServiceModel {
  final int serviceId;
  final String serviceName;
  final String cost;
  final bool state;

  const ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.cost,
    required this.state,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: (json['serviceId'] as num?)?.toInt() ?? 0,
      serviceName: json['serviceName']?.toString() ?? '',
      cost: json['cost']?.toString() ?? '0',
      state: json['state'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'cost': cost,
      'state': state,
    };
  }
}