import 'dart:convert';

import 'package:family/core/models/price.dart';

class PriceSerializer extends Converter<Map, Price> {
  static const integersKey = 'integers';
  static const decimalsKey = 'decimals';
  static const currencyKey = 'currency';

  @override
  Price convert(Map input) {
    if (input == null) {
      print('PriceSerializer: The input is null.');
      return null;
    }

    final int integers = int.parse(input[integersKey]);
    final int decimals = int.parse(input[decimalsKey]);
    final String currency = input[currencyKey];

    Price price;

    try {
      price = Price(
        integers: integers,
        decimals: decimals,
        currency: currency,
      );
    } catch (e) {
      print('PriceSerializer: Error while parsing price. ${e.toString()}');
    }

    return price;
  }
}

extension PriceToJson on Price {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      PriceSerializer.integersKey: this.integers.toString(),
      PriceSerializer.decimalsKey: this.decimals.toString(),
      PriceSerializer.currencyKey: this.currency
    };
  }
}
