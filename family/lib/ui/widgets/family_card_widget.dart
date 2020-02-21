import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/member_preview.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/widgets/family_payment_info_widget.dart';
import 'package:family/ui/widgets/gradient_fade_container.dart';
import 'package:family/ui/widgets/overlapping_avatars_widget.dart';
import 'package:family/ui/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double _cardHeight = 250.0;

class FamilyCardWidget extends StatelessWidget {
  final FamilyCard familyCard;
  final Function(Family) onTap;
  final Function(Family) onLongPress;

  const FamilyCardWidget({
    Key key,
    this.familyCard,
    this.onTap,
    this.onLongPress,
  })  : assert(familyCard != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap(familyCard.family),
      onLongPress:
          onLongPress == null ? null : () => onLongPress(familyCard.family),
      child: GradientFadeContainer(
        height: _cardHeight,
        background: _getImage(),
        foreground: _getForeground(),
      ),
    );
  }

  Widget _getImage() => Center(child: _getPlaceholderPhoto());

  Widget _getPlaceholderPhoto() => SvgPicture.asset(
        Assets.familyCoverPhotoPlaceholder,
        semanticsLabel: 'Family cover photo placeholder',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      );

  Widget _getForeground() => Positioned(
        bottom: _cardHeight * 0.2,
        left: 16.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getPaymentDateInfo(),
            SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                _getFamilyName(),
                SizedBox(width: 8.0),
                _getPaymentPriceAndTypeInfo(),
              ],
            ),
            SizedBox(height: 16.0),
            _getMemberAvatars(),
          ],
        ),
      );

  Widget _getPaymentDateInfo() {
    final String paymentInfo =
        '${familyCard.humanPaymentDate} (${familyCard.daysBeforePayment})'
            .toUpperCase();
    return Text(
      paymentInfo,
      style: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        fontSize: TextSizes.familyPaymentInfo,
      ),
    );
  }

  Widget _getFamilyName() => Text(
        familyCard.family.name,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: TextSizes.familyName,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _getPaymentPriceAndTypeInfo() => FamilyPaymentInfoWidget(
        price: familyCard.family.price,
        subscriptionType: familyCard.family.subscriptionType,
      );

  Widget _getMemberAvatars() {
    if (familyCard.family.membersPreview.isEmpty) return Container();

    final double avatarSize = 24.0;
    List<Widget> avatars = familyCard.family.membersPreview
        .map((MemberPreview preview) => UserAvatarWidget(
              photoUrl: preview.photoUrl,
              name: preview.name,
              size: avatarSize,
            ))
        .toList();

    return OverlappingAvatarsWidget(
      avatars: avatars,
      singleAvatarSize: avatarSize,
    );
  }
}
