import 'package:family/core/serializers/date_time_serializer.dart';
import 'package:family/core/serializers/family_serializer.dart';
import 'package:family/core/serializers/member_serializer.dart';
import 'package:family/core/serializers/members_preview_serializer.dart';
import 'package:family/core/serializers/price_serializer.dart';
import 'package:family/core/serializers/subscription_serializer.dart';
import 'package:family/core/serializers/subscription_type_serializer.dart';
import 'package:family/core/services/api.dart';
import 'package:family/core/services/authentication_service.dart';
import 'package:family/core/services/firestore_storage_service.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/family_model.dart';
import 'package:family/core/viewmodels/home_model.dart';
import 'package:family/core/viewmodels/login_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/core/viewmodels/no_route_model.dart';
import 'package:family/core/viewmodels/user_menu_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());
  locator
      .registerLazySingleton<StorageService>(() => FirestoreStorageService());

  locator.registerLazySingleton(() => DateTimeSerializer());
  locator.registerLazySingleton(() => FamilySerializer());
  locator.registerLazySingleton(() => PriceSerializer());
  locator.registerLazySingleton(() => SubscriptionTypeSerializer());
  locator.registerLazySingleton(() => MemberSerializer());
  locator.registerLazySingleton(() => MemberPreviewSerializer());
  locator.registerLazySingleton(() => SubscriptionSerializer());

  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => NoRouteModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => FamilyBuilderModel());
  locator.registerFactory(() => MemberBuilderModel());
  locator.registerFactory(() => FamilyModel());
  locator.registerFactory(() => UserMenuModel());
}
