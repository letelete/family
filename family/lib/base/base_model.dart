import 'package:family/core/state/view_state.dart';
import 'package:flutter/cupertino.dart';

class BaseModel extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;

  ViewState get viewState => _viewState;

  void setState(ViewState viewState) {
    this._viewState = viewState;
    notifyListeners();
  }
}