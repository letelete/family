import 'package:family/core/models/family.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:flutter/cupertino.dart';

const Map<SubscriptionType, String> _subscriptionNames = {
  SubscriptionType.WEEKLY: 'week',
  SubscriptionType.MONTHLY: 'month',
  SubscriptionType.YEARLY: 'year',
};

class FamilyPaymentInfoWidget extends StatelessWidget {
  final String price;
  final SubscriptionType subscriptionType;

  const FamilyPaymentInfoWidget({
    Key key,
    this.price,
    this.subscriptionType,
  })  : assert(price != null),
        assert(subscriptionType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> priceParts = price.split(',');
    String integerPrice = priceParts.length >= 1 ? priceParts[0] : '0';
    String predecimalWithCurrency =
        priceParts.length >= 2 ? priceParts[1] : 'USD';
    String subscriptionTypeName = _subscriptionNames[this.subscriptionType];

    final String largeContent = integerPrice;
    final String smallContent = '$predecimalWithCurrency/$subscriptionTypeName';

    return Row(
      children: <Widget>[
        _getLargeText(largeContent),
        _getSmallText(smallContent),
      ],
    );
  }

  Widget _getLargeText(String content) => Text(
        content,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: TextSizes.familyPriceLarge,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _getSmallText(String content) => Text(
        content,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: TextSizes.familyPriceSmall,
          fontWeight: FontWeight.normal,
        ),
      );
}
