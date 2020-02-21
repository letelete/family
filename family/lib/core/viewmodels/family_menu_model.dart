import 'package:family/base/base_model.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class FamilyMenuModel extends BaseModel {
  StorageService _storageService = locator<StorageService>();

  Future<bool> removeFamily(String userId, String familyId) async {
    bool success = await _storageService.removeUserFamily(userId, familyId);
    return success;
  }
}
