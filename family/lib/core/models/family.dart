import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/price.dart';
import 'package:uuid/uuid.dart';

class Family {
  final String id;
  final String name;
  final DateTime paymentDay;
  final Price price;
  final SubscriptionType subscriptionType;
  final List<Member> members;

  const Family({
    this.id,
    this.name,
    this.paymentDay,
    this.price,
    this.subscriptionType,
    this.members,
  })  : assert(id != null && id != ''),
        assert(name != null && name != ''),
        assert(paymentDay != null),
        assert(price != null),
        assert(subscriptionType != null),
        assert(members != null);

  static String formatName(String name) {
    name.trim();
    return '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }

  static String generateId() => Uuid().v1();
}
