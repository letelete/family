import 'package:family/base/base_model.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class FamilyMenuModel extends BaseModel {
  StorageService _storageService = locator<StorageService>();

  Future<bool> updateUserFamily(String userId, Family family) async {
    bool success = await _storageService.updateUserFamily(userId, family);
    return success;
  }

  Future<bool> deleteFamily(String userId, String familyId) async {
    bool success = await _storageService.removeUserFamily(userId, familyId);
    return success;
  }
}
