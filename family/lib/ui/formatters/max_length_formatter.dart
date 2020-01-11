import 'package:family/ui/shared/shared.dart';
import 'package:flutter/services.dart';

class PriceInputFormatter extends TextInputFormatter {
  final int maxIntegersLength;
  final int maxDecimalsLength;

  PriceInputFormatter({
    this.maxIntegersLength,
    this.maxDecimalsLength,
  })  : assert(maxIntegersLength == null || maxIntegersLength > 0),
        assert(maxDecimalsLength == null || maxDecimalsLength > 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0 ||
        maxIntegersLength == null ||
        maxDecimalsLength == null) {
      return newValue;
    }

    const separator = AppShared.priceDecimalSeparator;

    String value = newValue.text;
    value.trim();

    value = value.replaceAll(
      RegExp('[^0-9${AppShared.priceDecimalSeparator}]'),
      separator,
    );

    int separatorOccurences =
        value.split('').where((String str) => str == separator).toList().length;
    if (separatorOccurences > 1) {
      return oldValue;
    }

    int separatorIndex = value.indexOf(separator);
    bool containsSeparator = separatorIndex != -1;

    String integers =
        containsSeparator ? value.substring(0, separatorIndex) : value;

    String decimals =
        containsSeparator ? value.substring(separatorIndex + 1) : '';

    bool charsLimitOverflow = integers.length > maxIntegersLength ||
        decimals.length > maxDecimalsLength;
    if (charsLimitOverflow) {
      return oldValue;
    }

    bool inputStartsFromSepartor = integers.isEmpty;
    if (inputStartsFromSepartor) {
      value = '0$separator$decimals';
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }

    integers = int.parse(integers).toString();
    value = '$integers${containsSeparator ? '$separator$decimals' : ''}';
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}
