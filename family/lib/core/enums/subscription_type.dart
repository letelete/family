enum SubscriptionType { weekly, monthly, yearly }

SubscriptionType getSubscriptionTypeFromString(String str) {
  for (SubscriptionType subscriptionType in SubscriptionType.values) {
    if (subscriptionType.toString() == str) {
      return subscriptionType;
    }
  }
  return null;
}

class SubscriptionTypeName {
  static const Map<SubscriptionType, String> asPeriod = {
    SubscriptionType.weekly: 'Week',
    SubscriptionType.monthly: 'Month',
    SubscriptionType.yearly: 'Year',
  };
}
