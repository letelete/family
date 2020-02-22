import 'package:family/base/base_model.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class FamilyModel extends BaseModel {
  StorageService _storageService = locator<StorageService>();

  List<Member> _members;

  List<Member> get members => _members ?? [];

  Future<bool> fetchMembers(String userId, String familyId) async {
    setState(ViewState.busy);
    List<Member> data =
        await _storageService.getUserFamilyMembers(userId, familyId);
    if (data != null) {
      _members = data;
    }
    setState(ViewState.idle);
    return data != null;
  }

  Future<void> onMemberBuilderResponse(
    String userId,
    String familyId,
    BuilderResponse<Member> response,
  ) async {
    setState(ViewState.busy);
    if (response == null || response.response == BuildResponse.cancel) {
      return;
    }
    if (response.response == BuildResponse.success) {
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
