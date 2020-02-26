import 'dart:async';

import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';

abstract class StorageService {
  Future<bool> addUserFamily(String userId, Family family);

  Future<bool> updateUserFamily(String userId, Family family);

  Future<bool> removeUserFamily(String userId, String familyId);

  Stream<Family> streamFamily(String userId, String familyId);

  Stream<List<Family>> streamUserFamilies(String userId);

  Stream<List<Member>> streamFamilyMembers(String userId, String familyId);

  Future<bool> addUserFamilyMember(
      String userId, String familyId, Member member);
}
