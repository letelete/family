import 'dart:convert';

import 'package:family/core/models/price.dart';

const _integers = 'integers';
const _decimals = 'decimals';
const _currency = 'currency';

class PriceSerializer extends Converter<Map, Price> {
  @override
  Price convert(Map input) {
    if (input == null) {
      print('PriceSerializer: The input is null.');
      return null;
    }

    final int integers = int.parse(input[_integers]);
    final int decimals = int.parse(input[_decimals]);
    final String currency = input[_currency];

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
      _integers: this.integers.toString(),
      _decimals: this.decimals.toString(),
      _currency: this.currency
    };
  }
}
