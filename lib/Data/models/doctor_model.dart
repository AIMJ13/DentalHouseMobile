class DoctorModel {
  final int id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? specialtyName;
  final List<int> specialtyIds;
  final bool isActive;

  const DoctorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.specialtyName,
    this.specialtyIds = const [],
    required this.isActive,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get titleFullName => 'Dr. $fullName';

  String get code {
    if (id <= 0) return 'DOC-000';
    return 'DOC-${id.toString().padLeft(3, '0')}';
  }

  String get specialtyDisplay {
    if (specialtyName != null && specialtyName!.trim().isNotEmpty) {
      return specialtyName!.trim();
    }
    return 'Odontología General';
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    List<int> ids = [];
    if (json['specialtyIds'] is List) {
      ids = (json['specialtyIds'] as List)
          .map((e) => (e as num?)?.toInt() ?? 0)
          .where((e) => e > 0)
          .toList();
    } else if (json['specialties'] is List) {
      ids = (json['specialties'] as List)
          .map((e) => (e is Map ? (e['specialtyId'] as num?)?.toInt() : null) ?? 0)
          .where((e) => e > 0)
          .toList();
    }

    String? specName = json['specialtyName']?.toString();
    if ((specName == null || specName.isEmpty) && json['specialties'] is List) {
      final specs = json['specialties'] as List;
      if (specs.isNotEmpty && specs.first is Map) {
        specName = specs.first['specialtyName']?.toString();
      }
    }

    return DoctorModel(
      id: (json['doctorId'] ?? json['id'] as num?)?.toInt() ?? 0,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString(),
      specialtyName: specName,
      specialtyIds: ids,
      isActive: (json['isActive'] ?? json['state']) as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'specialtyName': specialtyName,
      'specialtyIds': specialtyIds,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toCreateJson({int? defaultSpecialtyId}) {
    final list = specialtyIds.isNotEmpty
        ? specialtyIds
        : (defaultSpecialtyId != null ? [defaultSpecialtyId] : [1]);
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone ?? '',
      'specialtyIds': list,
      'specialtyId': list.first,
      'state': isActive,
    };
  }

  Map<String, dynamic> toUpdateJson({int? defaultSpecialtyId}) {
    final list = specialtyIds.isNotEmpty
        ? specialtyIds
        : (defaultSpecialtyId != null ? [defaultSpecialtyId] : [1]);
    return {
      'doctorId': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone ?? '',
      'specialtyIds': list,
      'specialtyId': list.first,
      'state': isActive,
    };
  }
}
