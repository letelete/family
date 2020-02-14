import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/serializers/family_serializer.dart';
import 'package:family/core/serializers/member_serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family/core/services/storage_service.dart';
import 'package:family/locator.dart';

class _Path {
  static const users = 'users';
  static const families = 'families';
  static const members = 'members';

  static String generate(List<String> paths) {
    assert(paths != null && paths.isNotEmpty);
    return paths.reduce((a, b) => a + '/$b');
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
  Future<bool> addUserFamilyMember(
      String userId, String familyId, Member member) async {
    final Map memberData = member.toJson();
    final String path = _Path.generate([
      _Path.users,
      userId,
      _Path.families,
      familyId,
      _Path.members,
      member.id
    ]);
    bool success = false;
    await _firestore
        .document(path)
        .setData(memberData)
        .then((_) => success = true)
        .catchError(print);
    return success;
  }

  @override
  Future<bool> addUserFamily(String userId, Family family) async {
    final Map familyData = family.toJson();
    final String path =
        _Path.generate([_Path.users, userId, _Path.families, family.id]);
    print(path);
    bool success = false;
    await _firestore
        .document(path)
        .setData(familyData)
        .then((_) => success = true)
        .catchError(print);
    return success;
  }

  @override
  Future<Family> getFamily(String familyId) async {
    Family family;
    await _firestore.document(familyId).get().then((DocumentSnapshot doc) {
      family = _familySerializer.convert(doc.data);
    }).catchError(print);
    return family;
  }

  @override
  Future<List<Member>> getUserFamilyMembers(
      String userId, String familyId) async {
    final String path = _Path.generate(
        [_Path.users, userId, _Path.families, familyId, _Path.members]);
    List<Member> members;
    await _firestore
        .collection(path)
        .getDocuments()
        .then((QuerySnapshot query) {
      members = query.documents
          .map((DocumentSnapshot doc) => _memberSerializer.convert(doc.data))
          .toList();
    }).catchError(print);
    return members;
  }

  @override
  Future<List<Family>> getUserFamilies(String userId) async {
    final String path = _Path.generate([_Path.users, userId, _Path.families]);
    List<Family> families;
    await _firestore
        .collection(path)
        .getDocuments()
        .then((QuerySnapshot query) {
      families = [
        for (DocumentSnapshot doc in query.documents)
          _familySerializer.convert(doc.data)
      ];
    }).catchError(print);
    return families;
  }
}