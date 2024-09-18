import 'package:rest_api_test/domain/entities/user.dart';
import 'package:rest_api_test/domain/repositories/user_repository.dart';

class RegisterUserUseCase {
  final UserRepository repository;

  RegisterUserUseCase(this.repository);

  Future<void> execute(User user) {
    return repository.registerUser(user);
  }
}
