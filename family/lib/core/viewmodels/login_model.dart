import 'package:family/base/base_model.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/services/authentication_service.dart';
import 'package:family/locator.dart';

class LoginModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Future<bool> login() async {
    setState(ViewState.busy);
    bool success = await _authenticationService.login();
    setState(ViewState.idle);
    return success;
  }
}
