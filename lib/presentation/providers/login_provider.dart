import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class LoginProvider extends ChangeNotifier {
  final UserService userService;

  LoginProvider(this.userService);

  void login() => userService.callRepo();
}
