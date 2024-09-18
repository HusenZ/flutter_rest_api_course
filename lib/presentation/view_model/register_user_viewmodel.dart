import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:rest_api_test/domain/entities/user.dart';
import 'package:rest_api_test/domain/usecases/register_user_usecase.dart';

class RegisterUserViewModel extends ChangeNotifier {
  final RegisterUserUseCase registerUserUseCase;

  RegisterUserViewModel(this.registerUserUseCase);

  Future<String> registerUser(
      String fullname, String username, String email, String password) async {
    if ([fullname, username, email, password].any((field) => field.isEmpty)) {
      return "All fields are required";
    }

    final user = User(
        fullname: fullname,
        username: username,
        email: email,
        password: password);

    try {
      await registerUserUseCase.execute(user);
      return "User Registered Successfully";
    } catch (e) {
      return e.toString();
    }
  }
}
