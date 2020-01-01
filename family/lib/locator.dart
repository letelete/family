import 'package:family/core/services/authentication_service.dart';
import 'package:family/core/viewmodels/login_model.dart';
import 'package:get_it/get_it.dart';

import 'core/services/api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());

  locator.registerFactory(() => LoginModel());
}