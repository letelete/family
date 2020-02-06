import 'dart:async';

import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';

abstract class StorageService {
  Future<bool> addUserFamily(String userId, Family family);
  Future<bool> addFamilyMember(String familyId, Member member);
  Future<List<Member>> getFamilyMembers(String familyId);
  Future<List<Family>> getUserFamilies(String userId);
  Future<Family> getFamily(String familyId);
}
