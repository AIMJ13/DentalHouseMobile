class UserModel {
  final int id;
  final String userName;
  final String email;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'roles': roles,
    };
  }
}
