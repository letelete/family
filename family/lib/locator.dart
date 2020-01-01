import 'package:family/core/services/api.dart';
import 'package:family/core/services/authentication_service.dart';
import 'package:family/core/services/time.dart';
import 'package:family/core/viewmodels/home_model.dart';
import 'package:family/core/viewmodels/login_model.dart';
import 'package:family/core/viewmodels/no_route_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => Time());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => NoRouteModel());
  locator.registerFactory(() => HomeModel());
}
