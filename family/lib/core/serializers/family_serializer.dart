import 'dart:convert';

import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/price.dart';
import 'package:family/core/serializers/date_time_serializer.dart';
import 'package:family/core/serializers/member_serializer.dart';
import 'package:family/core/serializers/price_serializer.dart';
import 'package:family/core/serializers/subscription_type_serializer.dart';
import 'package:family/locator.dart';

const _id = 'id';
const _name = 'name';
const _paymentDay = 'paymentDay';
const _price = 'price';
const _subscriptionType = 'subscripionType';
const _members = 'members';

class FamilySerializer extends Converter<Map, Family> {
  PriceSerializer _priceSerializer = locator<PriceSerializer>();
  DateTimeSerializer _dateTimeSerializer = locator<DateTimeSerializer>();
  MemberSerializer _memberSerializer = locator<MemberSerializer>();
  SubscriptionTypeSerializer _subscriptionTypeSerializer =
      locator<SubscriptionTypeSerializer>();

  @override
  Family convert(Map input) {
    if (input == null) {
      print("FamilySerializer. The input is null.");
      return null;
    }

    final String id = input[_id];
    final String name = input[_name];
    final DateTime paymentDay = _dateTimeSerializer.convert(input[_paymentDay]);
    final Price price = _priceSerializer.convert(input[_price]);
    final SubscriptionType subscriptionType =
        _subscriptionTypeSerializer.convert(input[_subscriptionType]);
    final List<Member> members =
        _memberSerializer.convert(input[_members]).toList();

    Family family;

    try {
      family = Family(
        id: id,
        name: name,
        paymentDay: paymentDay,
        price: price,
        subscriptionType: subscriptionType,
        members: [],
      );
    } catch (e) {
      print('FamilySerializer. Could not create Family object. ${e.toString()}');
    }

    return family;
  }
}

extension FamilyToJson on Family {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _id: this.id,
      _name: this.name,
      _paymentDay: this.paymentDay.toJson(),
      _price: this.price.toJson(),
      _subscriptionType: this.subscriptionType.toString(),
      _members: this.members.map((member) => member.toJson()).toList(),
    };
  }
}
