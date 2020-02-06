import 'package:family/base/base_model.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class FamilyModel extends BaseModel {
  StorageService _storageService = locator<StorageService>();

  Family _family;
  List<Member> _members;

  List<Member> get members => _members ?? [];

  Future<bool> addNewMember(
    String userId,
    Member member,
    String familyId,
  ) async {
    setState(ViewState.busy);
    bool success = false;
    setState(ViewState.idle);
    return success;
  }
}
