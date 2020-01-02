import 'package:family/core/models/member.dart';

enum SubscriptionType { WEEKLY, MONTHLY, YEARLY }

class Family {
  final DateTime paymentDay;
  final String name;
  final String price;
  final SubscriptionType subscriptionType;
  final List<Member> members;
  final String photoUrl;

  const Family({
    this.paymentDay,
    this.name,
    this.price,
    this.subscriptionType,
    this.members,
    this.photoUrl,
  })  : assert(paymentDay != null),
        assert(name != null && name != ''),
        assert(price != null && price != ''),
        assert(subscriptionType != null),
        assert(members != null);
}
