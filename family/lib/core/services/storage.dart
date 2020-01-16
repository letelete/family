import 'package:family/core/models/family.dart';
import 'package:family/core/serializers/family_serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family/locator.dart';

const _familyPath = "families";

class StorageService {
  final _database = Firestore.instance;

  FamilySerializer _familySerializer = locator<FamilySerializer>();

  Future<bool> addNewFamily(Family family) async {
    Map<String, dynamic> familyAsJson = family.toJson();
    bool success = true;
    await _database
        .collection(_familyPath)
        .document(family.id)
        .setData(familyAsJson)
        .catchError((error) {
      print('Error adding new family to database. ${error.toString()}');
      print('Given Family object: ${family.toString()}');
      print('Family json: ${familyAsJson.toString()}');
      success = false;
    });
    return success;
  }

  Future<List<Family>> getUserFamilies() async {
    List<Family> data = [];
    await _database
        .collection(_familyPath)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      data = snapshot.documents
          .map((DocumentSnapshot document) =>
              _familySerializer.convert(document.data))
          .toList();
    }).catchError((error) {
      print('Error fetching user families from database. ${error.toString()}');
      data = null;
    });
    return data;
  }
}
