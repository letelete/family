import 'package:family/core/models/member.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/widgets/user_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:family/core/services/time.dart';

class MemberTileWidget extends StatelessWidget {
  final Function(Member member) onTap;
  final Function(Member member) onLongPress;
  final Member member;

  const MemberTileWidget({
    Key key,
    this.onTap,
    this.onLongPress,
    this.member,
  })  : assert(member != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final String memberTransactionStatus = member.paid ? "PAID" : "UNPAID";
    final Color memberTransactionColor =
        member.paid ? AppColors.textSecondary : Colors.redAccent;
    final String nextPaymentInfo = member.paid
        ? 'Next payment on ${member.nextPayment.toHuman()}'
        : 'Payment time expired ${member.nextPayment.durationBetween(Time.now()).toHuman()}';

    Widget memberAvatar = UserAvatarWidget(
      name: member.name,
      photoUrl: member.photoUrl,
    );

    Widget memberName = Container(
      child: Text(
        member.name,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: TextSizes.memberName,
        ),
      ),
    );

    Widget memberHasPaid = Container(
      child: Text(
        memberTransactionStatus,
        style: TextStyle(
          color: memberTransactionColor,
          fontWeight: FontWeight.bold,
          fontSize: TextSizes.memberPaidStatus,
        ),
      ),
    );

    Widget nextMemberPayment = Container(
      child: Text(
        nextPaymentInfo,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.normal,
          fontSize: TextSizes.memberPaymentInfo,
        ),
      ),
    );

    return InkWell(
      onTap: () {
        if (onTap != null) return onTap(member);
      },
      onLongPress: () {
        if (onLongPress != null) return onLongPress(member);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            memberAvatar,
            SizedBox(width: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                memberName,
                SizedBox(height: 2.0),
                memberHasPaid,
                SizedBox(height: 4.0),
                nextMemberPayment,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
