import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/member_preview.dart';
import 'package:family/core/models/price.dart';
import 'package:uuid/uuid.dart';

class Family {
  final String id;
  final String name;
  final DateTime paymentDay;
  final Price price;
  final SubscriptionType subscriptionType;
  final List<MemberPreview> membersPreview;

  const Family({
    this.id,
    this.name,
    this.paymentDay,
    this.price,
    this.subscriptionType,
    this.membersPreview,
  })  : assert(id != null && id != ''),
        assert(name != null && name != ''),
        assert(paymentDay != null),
        assert(price != null),
        assert(subscriptionType != null),
        assert(membersPreview != null);

  static String generateId() => Uuid().v1();
}
