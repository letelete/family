import 'package:family/core/enums/subscription_type.dart';

class Subscription {
  final SubscriptionType subscriptionType;

  /// Represents the amount of subscription time unit between two subscription
  /// payment dates.
  ///
  /// The time unit stands for amount of units described in [SubscriptionType].
  /// For example:
  /// [subscriptionType] = SubscriptionType.weekly
  /// [tresholdBetweenPayments] = 2;
  /// Means, the subscription ends every two week.
  /// The subscription end most often means it requires
  /// to take a money charge for the next time unit of usage passed.
  final int tresholdBetweenPayments;

  const Subscription({
    this.subscriptionType,
    this.tresholdBetweenPayments,
  })  : assert(subscriptionType != null),
        assert(tresholdBetweenPayments != null),
        assert(
          tresholdBetweenPayments > 0,
          'Treshold between two dates must be a positive number',
        );
}
