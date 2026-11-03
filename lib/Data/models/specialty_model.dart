class SpecialtyModel {
  final int specialtyId;
  final String specialtyName;
  final bool state;

  const SpecialtyModel({
    required this.specialtyId,
    required this.specialtyName,
    required this.state,
  });

  String get code {
    if (specialtyId <= 0) return 'ESP-000';
    return 'ESP-${specialtyId.toString().padLeft(3, '0')}';
  }

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      specialtyId: (json['specialtyId'] ?? json['id'] as num?)?.toInt() ?? 0,
      specialtyName: json['specialtyName']?.toString() ?? '',
      state: (json['state'] ?? json['isActive']) as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialtyId': specialtyId,
      'specialtyName': specialtyName,
      'state': state,
    };
  }
}
