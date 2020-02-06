import 'package:family/core/models/subscripton.dart';
import 'package:uuid/uuid.dart';

class Member {
  final String id;
  final String name;
  final String photoUrl;
  final bool paid;
  final DateTime nextPayment;
  final Subscription subscription;
  final DateTime createdAt;

  const Member({
    this.id,
    this.name,
    this.photoUrl,
    this.paid,
    this.nextPayment,
    this.subscription,
    this.createdAt,
  })  : assert(id != null && id != ''),
        assert(name != null && name != ''),
        assert(paid != null),
        assert(nextPayment != null),
        assert(subscription != null),
        assert(createdAt != null);

  static String generateId() => Uuid().v1();
}
