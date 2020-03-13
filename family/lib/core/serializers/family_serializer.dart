import 'dart:convert';

import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/member_preview.dart';
import 'package:family/core/models/price.dart';
import 'package:family/core/serializers/date_time_serializer.dart';
import 'package:family/core/serializers/members_preview_serializer.dart';
import 'package:family/core/serializers/price_serializer.dart';
import 'package:family/core/serializers/subscription_type_serializer.dart';
import 'package:family/locator.dart';

class FamilySerializer extends Converter<Map, Family> {
  static const idKey = 'id';
  static const nameKey = 'name';
  static const paymentDayKey = 'payment_day';
  static const priceKey = 'price';
  static const subscriptionTypeKey = 'subscription_type';
  static const membersPreviewKey = 'members_preview';

  PriceSerializer _priceSerializer = locator<PriceSerializer>();
  DateTimeSerializer _dateTimeSerializer = locator<DateTimeSerializer>();
  MemberPreviewSerializer _memberPreviewSerializer =
      locator<MemberPreviewSerializer>();
  SubscriptionTypeSerializer _subscriptionTypeSerializer =
      locator<SubscriptionTypeSerializer>();

  @override
  Family convert(Map input) {
    if (input == null) {
      print("FamilySerializer. The input is null.");
      return null;
    }

    final String id = input[idKey];
    final String name = input[nameKey];
    final DateTime paymentDay =
        _dateTimeSerializer.convert(input[paymentDayKey]);
    final Price price = _priceSerializer.convert(input[priceKey]);
    final SubscriptionType subscriptionType =
        _subscriptionTypeSerializer.convert(input[subscriptionTypeKey]);

    List membersPreviewAsJson = input[membersPreviewKey];
    final List<MemberPreview> membersPreview = membersPreviewAsJson
        .map((previewAsJson) => _memberPreviewSerializer.convert(previewAsJson))
        .toList();

    Family family;

    try {
      family = Family(
        id: id,
        name: name,
        paymentDay: paymentDay,
        price: price,
        subscriptionType: subscriptionType,
        membersPreview: membersPreview,
      );
    } catch (e) {
      print(
          'FamilySerializer. Could not create Family object. ${e.toString()}');
    }

    return family;
  }
}

extension FamilyToJson on Family {
  List<Map> membersPreviewAsJson(List<MemberPreview> membersPreview) =>
      membersPreview.map((MemberPreview preview) => preview.toJson()).toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FamilySerializer.idKey: this.id,
      FamilySerializer.nameKey: this.name,
      FamilySerializer.paymentDayKey: this.paymentDay.toJson(),
      FamilySerializer.priceKey: this.price.toJson(),
      FamilySerializer.subscriptionTypeKey: this.subscriptionType.toJson(),
      FamilySerializer.membersPreviewKey:
          membersPreviewAsJson(this.membersPreview),
    };
  }
}
