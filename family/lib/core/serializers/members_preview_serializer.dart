import 'dart:convert';

import 'package:family/core/models/member_preview.dart';

class MemberPreviewSerializer extends Converter<Map, MemberPreview> {
  static const idKey = 'id';
  static const nameKey = 'name';
  static const photoUrlKey = 'photo_url';

  @override
  MemberPreview convert(Map memberPreview) {
    final String id = memberPreview[idKey];
    final String name = memberPreview[nameKey];
    final String photoUrl = memberPreview[photoUrlKey];

    MemberPreview memberPreviewObject;

    if (id == null || name == null) {
      return null;
    }

    try {
      memberPreviewObject = MemberPreview(
        id: id,
        name: name,
        photoUrl: photoUrl,
      );
    } catch (e) {
      print(
          'MemberPreviewSerializer: Error building a member. ${e.toString()}');
    }

    return memberPreviewObject;
  }
}

extension MemberPreviewToJson on MemberPreview {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      MemberPreviewSerializer.idKey: this.id,
      MemberPreviewSerializer.nameKey: this.name,
      MemberPreviewSerializer.photoUrlKey: this.photoUrl,
    };
  }
}
