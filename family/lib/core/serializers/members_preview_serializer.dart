import 'dart:convert';

import 'package:family/core/models/member_preview.dart';
import 'package:family/core/serializers/date_time_serializer.dart';
import 'package:family/locator.dart';

class MemberPreviewSerializer extends Converter<Map, MemberPreview> {
  static const idKey = 'id';
  static const nameKey = 'name';
  static const photoUrlKey = 'photo_url';
  static const createdAtKey = 'created_at';

  DateTimeSerializer _dateTimeSerializer = locator<DateTimeSerializer>();

  @override
  MemberPreview convert(Map memberPreview) {
    final String id = memberPreview[idKey];
    final String name = memberPreview[nameKey];
    final String photoUrl = memberPreview[photoUrlKey];
    final DateTime createdAt =
        _dateTimeSerializer.convert(memberPreview[createdAtKey]);

    MemberPreview memberPreviewObject;

    try {
      memberPreviewObject = MemberPreview(
        id: id,
        name: name,
        photoUrl: photoUrl,
        createdAt: createdAt,
      );
    } catch (error) {
      print(
          'MemberPreviewSerializer: Error building a member. ${error.toString()}');
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
      MemberPreviewSerializer.createdAtKey: this.createdAt.toJson(),
    };
  }
}
