class PatientModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String birthDate;
  final bool isActive;

  const PatientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.isActive,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get code {
    if (id <= 0) return 'PAC-000';
    return 'PAC-${id.toString().padLeft(3, '0')}';
  }

  String get formattedBirthDate {
    if (birthDate.isEmpty) return 'No registrada';
    return birthDate.split(' ')[0];
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: (json['patientId'] ?? json['id'] as num?)?.toInt() ?? 0,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      birthDate: json['birthDate']?.toString() ?? '',
      isActive: (json['state'] ?? json['isActive']) as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'birthDate': birthDate,
      'state': isActive,
    };
  }
}
