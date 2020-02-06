import 'dart:convert';

import 'package:family/core/models/member.dart';
import 'package:family/core/models/subscripton.dart';
import 'package:family/core/serializers/date_time_serializer.dart';
import 'package:family/core/serializers/subscription_serializer.dart';
import 'package:family/locator.dart';

class MemberSerializer extends Converter<Map, Member> {
  static const idKey = 'id';
  static const nameKey = 'name';
  static const nextPaymentKey = 'next_payment';
  static const paidKey = 'paid';
  static const photoUrlKey = 'photo_url';
  static const subscriptionKey = 'subscription';

  DateTimeSerializer _dateTimeSerializer = locator<DateTimeSerializer>();
  SubscriptionSerializer _subscriptionSerializer =
      locator<SubscriptionSerializer>();

  @override
  Member convert(Map member) {
    final String id = member[idKey];
    final String name = member[nameKey];
    final DateTime nextPayment =
        _dateTimeSerializer.convert(member[nextPaymentKey]);
    final bool paid = member[paidKey].toString().toLowerCase() == 'true';
    final String photoUrl = member[photoUrlKey];
    final Subscription subscription =
        _subscriptionSerializer.convert(member[subscriptionKey]);

    Member memberObject;

    if (id == null ||
        name == null ||
        nextPayment == null ||
        paid == null ||
        subscription == null) {
      return null;
    }

    try {
      memberObject = Member(
        id: id,
        name: name,
        nextPayment: nextPayment,
        paid: paid,
        photoUrl: photoUrl,
        subscription: subscription,
      );
    } catch (e) {
      print('MemberSerializer: Error building a member. ${e.toString()}');
    }

    return memberObject;
  }
}

extension MemberToJson on Member {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      MemberSerializer.idKey: this.id,
      MemberSerializer.nameKey: this.name,
      MemberSerializer.nextPaymentKey: this.nextPayment.toJson(),
      MemberSerializer.paidKey: this.paid.toString(),
      MemberSerializer.photoUrlKey: this.photoUrl,
      MemberSerializer.subscriptionKey: this.subscription.toJson(),
    };
  }
}
