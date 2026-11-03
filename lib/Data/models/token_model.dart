class TokenModel {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final int id;
  final String userName;
  final String email;
  final List<String> roles;

  TokenModel({
    required this.accessToken,
    this.tokenType = 'Bearer',
    this.expiresIn = 0,
    this.id = 0,
    this.userName = '',
    this.email = '',
    this.roles = const [],
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['token'] ?? json['accessToken'] ?? '',
      tokenType: json['tokenType'] ?? 'Bearer',
      expiresIn: json['expiresIn'] ?? 0,
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': accessToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'id': id,
      'userName': userName,
      'email': email,
      'roles': roles,
    };
  }
}
