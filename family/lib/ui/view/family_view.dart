import 'package:family/base/base_view.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/family_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/locator.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/view/builder_view/member/member_builder.dart';
import 'package:family/ui/view/builder_view/member/pages/page_creator.dart';
import 'package:family/ui/view/menu_view/views_implementation/family_menu.dart';
import 'package:family/ui/widgets/family_payment_info_widget.dart';
import 'package:family/ui/widgets/gradient_fade_container.dart';
import 'package:family/ui/widgets/linear_progress_indicator_widget.dart';
import 'package:family/ui/widgets/member_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FamilyView extends StatelessWidget {
  final Family givenFamily;

  const FamilyView(this.givenFamily, {Key key})
      : assert(givenFamily != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return BaseView<FamilyModel>(
      providers: [
        Provider<MemberBuilderModel>(
          create: (_) => locator<MemberBuilderModel>(),
        ),
      ],
      onModelReady: (model) {
        model.fetchFamily(user.id, givenFamily.id);
        model.fetchMembers(user.id, givenFamily.id);
      },
      builder: (BuildContext context, FamilyModel model, _) {
        final family = model.family ?? givenFamily;
        final familyCard = FamilyCard.fromFamily(family);
        showMemberBuilderForResults() async {
          final memberBuilder = MemberBuilder(
            pages: (model) => MemberPageCreator(model).allPages(
              familySubscription: family.subscriptionType,
            ),
          );
          final response = await Navigator.push<BuilderResponse<Member>>(
            context,
            MaterialPageRoute(builder: (_) => memberBuilder),
          );
          await model.onMemberBuilderResponse(user.id, family.id, response);
        }

        final appBar = SliverPersistentHeader(
          delegate: FamilySliverAppBar(
            expandedHeight: 200,
            familyCard: familyCard,
          ),
          floating: true,
        );

        final priceTile = SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          sliver: SliverToBoxAdapter(
            child: FamilyPaymentInfoWidget(
              price: family.price,
              subscriptionType: family.subscriptionType,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        );

        final membersList = SliverList(
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

        final floatingActionButton = Positioned(
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

        final progressIndicator = SliverToBoxAdapter(
          child: LinearProgressIndicatorWidget(),
        );

        return SafeArea(
          child: Material(
            color: AppColors.background,
            child: Stack(
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () => model.fetchFamily(user.id, family.id),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      appBar,
                      if (model.viewState == ViewState.busy) progressIndicator,
                      priceTile,
                      if (model.members.isNotEmpty) membersList,
                    ],
                  ),
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
