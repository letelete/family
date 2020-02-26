import 'package:family/core/models/family_card.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/view/menu_view/views_implementation/family_menu.dart';
import 'package:family/ui/widgets/gradient_fade_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FamilySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final FamilyCard familyCard;

  const FamilySliverAppBar({
    @required this.familyCard,
    @required this.expandedHeight,
  }) : assert(expandedHeight != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    const bodyHorizontalMargin = 16.0;
    const iconSize = 24.0;
    const iconPadding = 8.0;
    const iconButtonSize = iconSize + iconPadding * 2;
    const textColumnTopMargin = 8.0;
    final mediaSize = MediaQuery.of(context).size;
    final buttonsSpaceHorizontal =
        (iconButtonSize * 2) + (bodyHorizontalMargin * 4);
    final paymentInfoText =
        '${familyCard.humanPaymentDate} (${familyCard.daysBeforePayment})';
    final textColumnLeftMargin = iconButtonSize + 2 * bodyHorizontalMargin;
    final textColumnSpacing = (1 / expandedHeight) *
        textColumnTopMargin *
        (expandedHeight - shrinkOffset);

    final solidBackground = Container(
      width: mediaSize.width,
      height: minExtent,
      color: AppColors.background,
    );

    final dynamicBackground = Opacity(
      opacity: (expandedHeight - shrinkOffset) / expandedHeight,
      child: GradientFadeContainer(
        height: expandedHeight,
        background: SvgPicture.asset(
          Assets.familyCoverPhotoPlaceholder,
          semanticsLabel: 'Family cover photo placeholder',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
      ),
    );

    final horizontalMenuButton = Positioned(
      right: bodyHorizontalMargin,
      child: IconButton(
        iconSize: iconSize,
        onPressed: () => FamilyMenu(context, familyCard.family).show(),
        icon: Icon(
          Icons.more_vert,
          color: AppColors.textPrimary,
        ),
      ),
    );

    final backButton = Positioned(
      left: bodyHorizontalMargin,
      child: IconButton(
        iconSize: iconSize,
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
        ),
      ),
    );

    final familyName = Text(
      familyCard.family.name,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.familyName,
      ),
    );

    final familyPaymentInfo = Opacity(
      opacity: (expandedHeight - shrinkOffset) / expandedHeight,
      child: Text(
        paymentInfoText,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: TextSizes.familyPaymentInfo,
        ),
      ),
    );

    final textColumn = Positioned(
      width: mediaSize.width - buttonsSpaceHorizontal,
      left: textColumnLeftMargin,
      bottom: textColumnSpacing,
      top: textColumnTopMargin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          familyName,
          SizedBox(height: textColumnSpacing),
          familyPaymentInfo,
        ],
      ),
    );

    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        solidBackground,
        dynamicBackground,
        horizontalMenuButton,
        backButton,
        textColumn,
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
