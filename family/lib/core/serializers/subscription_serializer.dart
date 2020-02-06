import 'dart:convert';

import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/subscripton.dart';
import 'package:family/core/serializers/subscription_type_serializer.dart';
import 'package:family/locator.dart';

class SubscriptionSerializer extends Converter<Map, Subscription> {
  static const subscriptionTypeKey = 'subscription_type';
  static const tresholdBetweenPaymentsKey = 'treshold_between_payments';

  SubscriptionTypeSerializer _subscriptionTypeSerializer =
      locator<SubscriptionTypeSerializer>();

  @override
  Subscription convert(Map input) {
    if (input == null) {
      print('SubscriptionSerializer: The input is null.');
      return null;
    }

    final SubscriptionType subscriptionType =
        _subscriptionTypeSerializer.convert(input[subscriptionTypeKey]);
    final int tresholdBetweenPayments =
        int.parse(input[tresholdBetweenPaymentsKey]);

    Subscription subscription;

    try {
      subscription = Subscription(
        subscriptionType: subscriptionType,
        tresholdBetweenPayments: tresholdBetweenPayments,
      );
    } catch (e) {
      print(
          'SubscriptionSerializer: Error while parsing price. ${e.toString()}');
    }

    return subscription;
  }
}

extension SubscriptionToJson on Subscription {
  Map<String, dynamic> toJson() {
    return {
      SubscriptionSerializer.subscriptionTypeKey:
          this.subscriptionType.toString(),
      SubscriptionSerializer.tresholdBetweenPaymentsKey:
          this.tresholdBetweenPayments.toString(),
    };
  }
}
