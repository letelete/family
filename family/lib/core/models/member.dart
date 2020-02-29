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

  Member copyWith({
    String id,
    String name,
    String photoUrl,
    bool paid,
    DateTime nextPayment,
    Subscription subscription,
    DateTime createdAt,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      paid: paid ?? this.paid,
      nextPayment: nextPayment ?? this.nextPayment,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
