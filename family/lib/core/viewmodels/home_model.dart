import 'package:family/base/base_model.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/services/time.dart';
import 'package:family/core/state/view_state.dart';
import 'package:family/locator.dart';

class HomeModel extends BaseModel {
  Time _time = locator<Time>();

  List<FamilyCard> _families = [];
  String _todayHumanDate;

  List<FamilyCard> get families => _families;
  String get todayHumanDate => _todayHumanDate;

  // Todo:
  Future<bool> fetchFamilies() async {
    setState(ViewState.Busy);

    bool success = true;
    
    await Future.delayed(Duration(seconds: 2));
    setState(ViewState.Idle);
    return success;
  }

  bool fetchTodayDate() {
    DateTime todayDateTime = _time.getTodaysDateTime();
    this._todayHumanDate = _time.getHumanDate(todayDateTime);

    bool success = _todayHumanDate != null;
    return success;
  }
}
