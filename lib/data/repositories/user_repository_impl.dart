import 'package:rest_api_test/core/exceptions/server_exception.dart';
import 'package:rest_api_test/data/data_source/remote_data_source.dart';
import 'package:rest_api_test/domain/entities/user.dart';
import 'package:rest_api_test/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> registerUser(User user) async {
    try {
      await remoteDataSource.registerUser(user);
    } on ServerException {
      // Handle the exception or rethrow it
      rethrow;
    }
  }
}
