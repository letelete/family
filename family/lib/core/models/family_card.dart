import 'package:family/core/models/family.dart';
import 'package:family/core/services/time.dart';

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

  FamilyCard.fromFamily(Family family)
      : family = family,
        daysBeforePayment =
            Time.now().durationBetween(family.paymentDay).toHuman(),
        humanPaymentDate = family.paymentDay.toHuman();
}
