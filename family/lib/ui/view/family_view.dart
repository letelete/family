import 'package:family/base/base_view.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/models/build_data/build_data.dart';
import 'package:family/core/models/build_data/member_build_data.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/family_model.dart';
import 'package:family/router.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/widgets/family_payment_info_widget.dart';
import 'package:family/ui/widgets/gradient_fade_container.dart';
import 'package:family/ui/widgets/member_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FamilyView extends StatelessWidget {
  final Family family;

  const FamilyView(this.family, {Key key})
      : assert(family != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final FamilyCard familyCard = FamilyCard.fromFamily(family);

    return BaseView<FamilyModel>(
      builder: (BuildContext context, FamilyModel model, _) {
        Widget appBar = SliverPersistentHeader(
          delegate: FamilySliverAppBar(
            expandedHeight: 200,
            familyCard: familyCard,
          ),
          floating: true,
        );

        Widget priceTile = SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          sliver: SliverToBoxAdapter(
            child: FamilyPaymentInfoWidget(
              price: family.price,
              subscriptionType: family.subscriptionType,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        );

        Widget membersList = SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Member member = model.members.elementAt(index);
              return Container(
                child: MemberTileWidget(member: member),
                margin: EdgeInsets.only(top: index <= 0 ? 0.0 : 24.0),
              );
            },
            childCount: model.members.length,
          ),
        );

        Future<void> showMemberBuilderForResults() async {
          final builderArguments = MemberBuildData(
            memberFamilySubscription: family.subscriptionType,
          );

          var data = await Navigator.pushNamed(
            context,
            Paths.memberBuilder,
            arguments: builderArguments,
          );

          final member = data as BuildData<Member>;

          if (member == null) return;

          if (member.response == BuildResponses.success) {
            bool error = !await model.addNewMember(
              user.id,
              member.product,
              family.id,
            );
            if (error) print('FamilyView: Error while adding new member.');
          } else {
            print('FamilyView: Member response was not successfull.');
          }
        }

        Widget floatingActionButton = Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 32.0),
            child: FloatingActionButton.extended(
              label: const Text("ADD NEW MEMBER"),
              foregroundColor: AppColors.textPrimary,
              backgroundColor: AppColors.primaryAccent,
              onPressed: showMemberBuilderForResults,
            ),
          ),
        );

        return SafeArea(
          child: Material(
            color: AppColors.background,
            child: Stack(
              children: <Widget>[
                CustomScrollView(
                  slivers: <Widget>[
                    appBar,
                    priceTile,
                    if (model.members.isNotEmpty) membersList,
                  ],
                ),
                floatingActionButton,
              ],
            ),
          ),
        );
      },
    );
  }
}

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

    Widget solidBackground = Container(
      width: mediaSize.width,
      height: minExtent,
      color: AppColors.background,
    );

    Widget dynamicBackground = Opacity(
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

    Widget horizontalMenuButton = Positioned(
      right: bodyHorizontalMargin,
      child: IconButton(
        iconSize: iconSize,
        onPressed: _showFamilyMenu,
        icon: Icon(
          Icons.more_vert,
          color: AppColors.textPrimary,
        ),
      ),
    );

    Widget backButton = Positioned(
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

    Widget familyName = Text(
      familyCard.family.name,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: TextSizes.familyName,
      ),
    );

    Widget familyPaymentInfo = Opacity(
      opacity: (expandedHeight - shrinkOffset) / expandedHeight,
      child: Text(
        paymentInfoText,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: TextSizes.familyPaymentInfo,
        ),
      ),
    );

    Widget textColumn = Positioned(
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

  Future<void> _showFamilyMenu() async {
    print('Showing family menu.');
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
