import 'dart:async';

import 'package:family/core/models/user.dart';
import 'package:family/core/services/api.dart';
import 'package:family/locator.dart';

class AuthenticationService {
  Api _api = locator<Api>();

  StreamController<User> userController = StreamController<User>();

  Future<bool> login() async {
    final User fetchedUser = await _api.getUserProfile();

    bool success = fetchedUser != null;
    if (success) {
      userController.add(fetchedUser);
    }

    return success;
  }

  Future<bool> logout() async {
    bool success = await _api.logOutUser();
    return success;
  }
}
