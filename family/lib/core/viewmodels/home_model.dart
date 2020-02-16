import 'dart:async';

import 'package:family/base/base_model.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/services/authentication_service.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/core/services/time.dart';
import 'package:family/locator.dart';

class HomeModel extends BaseModel {
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  StorageService _storageService = locator<StorageService>();

  String _todayHumanDate;

  String get todayHumanDate => _todayHumanDate;

  Stream<List<Family>> streamFamilies(String userId) {
    return _storageService.streamUserFamilies(userId);
  }

  Future<void> fetchTodayDate() async {
    this._todayHumanDate = Time.now().toHuman();
  }

  Future<bool> logout() async {
    bool success = await _authenticationService.logout();
    return success;
  }

  Future<bool> addNewFamily(String userId, Family family) async {
    setState(ViewState.busy);
    bool success = await _storageService.addUserFamily(userId, family);
    setState(ViewState.idle);
    return success;
  }
}
