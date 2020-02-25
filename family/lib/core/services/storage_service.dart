import 'dart:async';

import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';

abstract class StorageService {
  Future<bool> addUserFamily(String userId, Family family);

  Future<bool> updateUserFamily(String userId, Family family);

  Future<bool> removeUserFamily(String userId, String familyId);

  Future<Family> getFamily(String userId, String familyId);

  Stream<List<Family>> streamUserFamilies(String userId);

  Future<bool> addUserFamilyMember(
      String userId, String familyId, Member member);

  Future<List<Member>> getUserFamilyMembers(String userId, String familyId);
}
