import 'package:rest_api_test/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> registerUser(User user);
}
