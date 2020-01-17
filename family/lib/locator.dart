import 'package:family/core/serializers/date_time_serializer.dart';
import 'package:family/core/serializers/family_serializer.dart';
import 'package:family/core/serializers/member_serializer.dart';
import 'package:family/core/serializers/price_serializer.dart';
import 'package:family/core/serializers/subscription_type_serializer.dart';
import 'package:family/core/services/api.dart';
import 'package:family/core/services/authentication_service.dart';
import 'package:family/core/services/storage.dart';
import 'package:family/core/services/time.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/home_model.dart';
import 'package:family/core/viewmodels/login_model.dart';
import 'package:family/core/viewmodels/no_route_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => StorageService());

  locator.registerLazySingleton(() => DateTimeSerializer());
  locator.registerLazySingleton(() => FamilySerializer());
  locator.registerLazySingleton(() => PriceSerializer());
  locator.registerLazySingleton(() => SubscriptionTypeSerializer());
  locator.registerLazySingleton(() => MemberSerializer());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => NoRouteModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => FamilyBuilderModel());
}
