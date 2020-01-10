import 'package:family/ui/shared/shared.dart';

class Price {
  final int integers;
  final int decimals;
  final String currency;

  const Price({
    this.integers,
    this.decimals,
    this.currency,
  })  : assert(integers != null),
        assert(decimals != null),
        assert(currency != null);

  const Price.initial()
      : this.integers = 0,
        this.decimals = 0,
        this.currency = 'USD';

  static Price fromRaw({String priceLine, String currency}) {
    assert(priceLine != null);
    assert(currency != null);

    const String separator = AppShared.priceDecimalSeparator;
    final List<String> priceParts = priceLine.split(separator);
    int integers, decimals;

    int parseToInt(String str) {
      if (str == null || str.trim().isEmpty) return 0;
      return int.parse(str);
    }

    if (priceParts.isNotEmpty) {
      String element = priceParts.elementAt(0);
      integers = parseToInt(element);
    }

    if (priceParts.length >= 2) {
      String element = priceParts.elementAt(1);
      decimals = parseToInt(element);
    }

    return Price(
      integers: integers ?? 0,
      decimals: decimals ?? 0,
      currency: currency.trim().toUpperCase(),
    );
  }

  @override
  String toString() {
    return '${this.integers}${AppShared.priceDecimalSeparator}${this.decimals}';
  }
}
