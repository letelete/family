enum SubscriptionType { weekly, monthly, yearly }

class SubscriptionTypeName {
  static const Map<SubscriptionType, String> asPeriod = {
    SubscriptionType.weekly: 'Week',
    SubscriptionType.monthly: 'Month',
    SubscriptionType.yearly: 'Year',
  };
}
