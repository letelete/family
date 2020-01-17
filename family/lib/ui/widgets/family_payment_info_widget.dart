import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/price.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:flutter/cupertino.dart';

class FamilyPaymentInfoWidget extends StatelessWidget {
  final Price price;
  final SubscriptionType subscriptionType;
  final MainAxisAlignment mainAxisAlignment;

  const FamilyPaymentInfoWidget({
    Key key,
    this.price,
    this.subscriptionType,
    this.mainAxisAlignment,
  })  : assert(price != null),
        assert(subscriptionType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final String subscriptionTypeName =
        SubscriptionTypeName.asPeriod[this.subscriptionType];

    final MainAxisAlignment mainAxisAlignment =
        this.mainAxisAlignment ?? MainAxisAlignment.start;
    final String largeContent = price.integers.toString();
    final String smallContent =
        '${price.decimals}${price.currency}/$subscriptionTypeName';

    return Row(
      mainAxisAlignment: mainAxisAlignment,
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
