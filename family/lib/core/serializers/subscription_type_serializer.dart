import 'dart:convert';

import 'package:family/core/enums/subscription_type.dart';

class SubscriptionTypeSerializer extends Converter<String, SubscriptionType> {
  @override
  SubscriptionType convert(String input) {
    if (input == null) {
      print('MemberSerializer: The input is null.');
      return null;
    }
    return getSubscriptionTypeFromString(input);
  }
}
