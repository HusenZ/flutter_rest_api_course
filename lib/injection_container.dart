import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:rest_api_test/data/data_source/remote_data_source.dart';
import 'package:rest_api_test/data/repositories/user_repository_impl.dart';
import 'package:rest_api_test/domain/repositories/user_repository.dart';
import 'package:rest_api_test/domain/usecases/register_user_usecase.dart';
import 'package:rest_api_test/presentation/view_model/register_user_viewmodel.dart';

final sl = GetIt.instance; // service locator

void init() {
  // Data sources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));

  // View models
  sl.registerFactory(() => RegisterUserViewModel(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
