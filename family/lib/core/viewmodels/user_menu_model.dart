import 'package:family/base/base_model.dart';
import 'package:family/core/services/authentication_service.dart';
import 'package:family/locator.dart';

class UserMenuModel extends BaseModel {
  AuthenticationService _authService = locator<AuthenticationService>();
  Future<void> logout() async {
    await _authService.logout();
  }
}
