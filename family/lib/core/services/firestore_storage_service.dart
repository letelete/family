import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/serializers/family_serializer.dart';
import 'package:family/core/serializers/member_serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class _Path {
  static families(String userId) {
    return 'users/$userId/families';
  }

  static members(String userId, String familyId) {
    return '${family(userId, familyId)}/members';
  }

  static family(String userId, String familyId) {
    return '${families(userId)}/$familyId';
  }

  static member(String userId, String familyId, String memberId) {
    return '${members(userId, familyId)}/$memberId';
  }
}

/// Describes all API calls for storing and receiving data.
///
/// Storage structure:
///
/// users [collection]
///  ...
/// |_ user_id [document]
///     ...
///    |_ families [collection]
///        ...
///       |_ family_id [document]
///          |_ members [collection]
///              ...
///             |_ member_id [document]
class FirestoreStorageService implements StorageService {
  final Firestore _firestore = Firestore.instance;

  FamilySerializer _familySerializer = locator<FamilySerializer>();
  MemberSerializer _memberSerializer = locator<MemberSerializer>();

  @override
  Future<bool> addUserFamily(String userId, Family family) async {
    final path = _Path.family(userId, family.id);
    final familyData = family.toJson();
    bool success = false;
    await _firestore
        .document(path)
        .setData(familyData)
        .then((_) => success = true)
        .catchError(print);
    return success;
  }

  @override
  Future<bool> updateUserFamily(String userId, Family family) async {
    final path = _Path.family(userId, family.id);
    final data = family.toJson();
    bool success = false;
    await _firestore
        .document(path)
        .updateData(data)
        .then((_) => success = true)
        .catchError(print);
    return success;
  }

  @override
  Future<bool> removeUserFamily(String userId, String familyId) async {
    final path = _Path.family(userId, familyId);
    bool success = false;
    await _firestore
        .document(path)
        .delete()
        .then((_) => success = true)
        .catchError(print);
    return success;
  }

  @override
  Stream<Family> streamFamily(String userId, String familyId) {
    final path = _Path.family(userId, familyId);
    return _firestore
        .document(path)
        .snapshots()
        .map((doc) => _familySerializer.convert(doc.data));
  }

  @override
  Stream<List<Family>> streamUserFamilies(String userId) {
    final path = _Path.families(userId);
    final ref = _firestore.collection(path);
    return ref.snapshots().map((snapshot) => snapshot.documents
        .map((doc) => _familySerializer.convert(doc.data))
        .toList());
  }

  @override
  Stream<List<Member>> streamFamilyMembers(String userId, String familyId) {
    final path = _Path.members(userId, familyId);
    final ref = _firestore.collection(path);
    return ref.snapshots().map((snapshot) => snapshot.documents
        .map((doc) => _memberSerializer.convert(doc.data))
        .toList());
  }

  @override
  Future<bool> addUserFamilyMember(
      String userId, String familyId, Member member) async {
    final path = _Path.member(userId, familyId, member.id);
    final memberData = member.toJson();
    bool success = false;
    await _firestore
        .document(path)
        .setData(memberData)
        .then((_) => success = true)
        .catchError(print);
    return success;
  }
}
