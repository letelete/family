import 'dart:convert';

import 'package:family/core/enums/subscription_type.dart';

class SubscriptionTypeSerializer extends Converter<String, SubscriptionType> {
  @override
  SubscriptionType convert(String input) {
    return SubscriptionType.values.firstWhere(
      (type) => type.toJson() == input,
      orElse: () => null,
    );
  }
}

extension SubscriptionTypeToJson on SubscriptionType {
  String toJson() {
    return this.toString().split(".").last;
  }
}
