import 'package:family/core/enums/view_state.dart';
import 'package:flutter/cupertino.dart';

class BaseModel extends ChangeNotifier {
  ViewState _viewState = ViewState.idle;

  ViewState get viewState => _viewState;

  void setState(ViewState viewState) {
    this._viewState = viewState;
    notifyListeners();
  }
}
