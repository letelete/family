import 'package:family/base/base_model.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class FamilyModel extends BaseModel {
  StorageService _storageService = locator<StorageService>();

  Stream<Family> streamFamily(String userId, String familyId) {
    return _storageService.streamFamily(userId, familyId);
  }

  Stream<List<Member>> streamMembers(String userId, String familyId) {
    return _storageService.streamFamilyMembers(userId, familyId);
  }

  Future<void> onMemberBuilderResponse(
    String userId,
    String familyId,
    BuilderResponse<Member> response,
  ) async {
    setState(ViewState.busy);
    if (response?.response == BuildResponse.success) {
      final member = response.product;
      await _storageService.addUserFamilyMember(
        userId,
        familyId,
        member,
      );
    }
    setState(ViewState.idle);
  }
}
