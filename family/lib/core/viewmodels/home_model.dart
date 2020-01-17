import 'package:family/base/base_model.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/services/authentication_service.dart';
import 'package:family/core/services/storage.dart';
import 'package:family/core/services/time.dart';
import 'package:family/locator.dart';

class HomeModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  StorageService _storageService = locator<StorageService>();

  List<FamilyCard> _families = [];
  String _todayHumanDate;

  List<FamilyCard> get families => _families;
  String get todayHumanDate => _todayHumanDate;

  Future<bool> fetchFamilies() async {
    setState(ViewState.busy);
    List<Family> data = await _storageService.getUserFamilies();
    bool success = data != null;
    if (success) {
      _families = data.map((family) => FamilyCard.fromFamily(family)).toList();
    }
    setState(ViewState.idle);
    return success;
  }

  bool fetchTodayDate() {
    this._todayHumanDate = Time.now().toHuman();
    bool success = _todayHumanDate != null;
    return success;
  }

  Future<bool> logout() async {
    bool success = await _authenticationService.logout();
    return success;
  }

  Future<bool> addNewFamily(Family family) async {
    setState(ViewState.busy);
    bool success = await _storageService.addNewFamily(family);
    if (success) {
      FamilyCard newFamilyCard = FamilyCard.fromFamily(family);
      _families.add(newFamilyCard);
    }
    setState(ViewState.idle);
    return success;
  }
}
