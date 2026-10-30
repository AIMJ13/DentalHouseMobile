class UserModel {
  final int id;
  final String userName;
  final String email;
  final bool state;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    this.state = true,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
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
      'state': state,
      'roles': roles,
    };
  }
}
