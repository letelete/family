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
    final User loggedOutUser = await _api.getLoggedOutUser();

    bool success = loggedOutUser == null;
    if (success) {
      userController.close();
    }

    return success;
  }
}
