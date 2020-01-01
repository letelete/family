import 'package:family/base/base_model.dart';
import 'package:family/core/state/view_state.dart';

const int _redirectionDurationDefault = 3;

class NoRouteModel extends BaseModel {
  Duration _redirectionTimeout = Duration(seconds: _redirectionDurationDefault);

  Duration get redirectionTimeout => _redirectionTimeout;

  Future<bool> redirectToHomeScreen() async {
    bool _undoneRedirection = _redirectionTimeout.inSeconds <= 0;
    if (_undoneRedirection) {
      _redirectionTimeout = Duration(seconds: _redirectionDurationDefault);
    }

    while (_redirectionTimeout.inSeconds > 0) {
      setState(ViewState.Busy);
      await Future.delayed(Duration(seconds: 1));
      this._redirectionTimeout -= Duration(seconds: 1);
      setState(ViewState.Idle);
    }
    return true;
  }
}
