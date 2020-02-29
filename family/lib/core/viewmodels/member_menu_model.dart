import 'package:family/base/base_model.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class MemberMenuModel extends BaseModel {
  StorageService _storageService = locator<StorageService>();

  Future<void> deleteMember(
      String userId, String familyId, String memberId) async {
    await _storageService.deleteMember(userId, familyId, memberId);
  }

  Future<void> updateMember(
      String userId, String familyId, Member member) async {
    await _storageService.updateMember(userId, familyId, member);
  }
}
