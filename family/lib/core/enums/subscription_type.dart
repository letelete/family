enum SubscriptionType { weekly, monthly, yearly }

class SubscriptionTypeName {
  static const Map<SubscriptionType, String> asPeriod = {
    SubscriptionType.weekly: 'week',
    SubscriptionType.monthly: 'month',
    SubscriptionType.yearly: 'year',
  };
}
