class UserModel {
  final int id;
  final String userName;
  final String email;
  final String? phone;
  final bool state;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    this.phone,
    this.state = true,
    required this.roles,
  });

  String get rol => roles.isNotEmpty ? roles.first : '';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString(),
      state: json['state'] ?? true,
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'phone': phone,
      'state': state,
      'roles': roles,
    };
  }
}