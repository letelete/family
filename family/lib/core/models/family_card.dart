import 'package:family/core/models/family.dart';

class FamilyCard {
  final Family family;
  final String humanPaymentDate;
  final String daysBeforePayment;

  FamilyCard({
    this.family,
    this.humanPaymentDate,
    this.daysBeforePayment,
  })  : assert(family != null),
        assert(humanPaymentDate != null),
        assert(daysBeforePayment != null);
}
