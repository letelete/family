import 'dart:async';

import 'package:family/core/models/user.dart';
import 'package:family/core/services/api.dart';
import 'package:family/locator.dart';

class AuthenticationService {
  Api _api = locator<Api>();

  StreamController<User> userController = StreamController<User>();

  Future<bool> login() async {
    final User fetchedUser = await _api.getUserProfile();
    final bool success = fetchedUser != null;
    if (success) userController.add(fetchedUser);
    return success;
  }

  Future<bool> logout() async {
    final bool success = await _api.logOutUser();
    if (success) userController.add(null);
    return success;
  }
}
