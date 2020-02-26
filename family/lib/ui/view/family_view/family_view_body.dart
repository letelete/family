import 'package:flutter/material.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/family_model.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/view/builder_view/member/member_builder.dart';
import 'package:family/ui/view/builder_view/member/pages/page_creator.dart';
import 'package:family/ui/view/family_view/app_bar.dart';
import 'package:family/ui/widgets/family_payment_info_widget.dart';
import 'package:family/ui/widgets/member_tile.dart';
import 'package:provider/provider.dart';

class FamilyViewBody extends StatelessWidget {
  final FamilyModel model;
  final Family family;

  const FamilyViewBody(
    this.model,
    this.family, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final familyCard = FamilyCard.fromFamily(family);

    showMemberBuilderForResults() async {
      final response = await Navigator.push<BuilderResponse<Member>>(
        context,
        MaterialPageRoute(
          builder: (_) => MemberBuilder(
            pages: (model) => MemberPageCreator(model).allPages(
              familySubscription: family.subscriptionType,
            ),
          ),
        ),
      );
      await model.onMemberBuilderResponse(
        user.id,
        family.id,
        response,
      );
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

    final membersList = StreamProvider<List<Member>>.value(
      initialData: <Member>[],
      value: model.streamMembers(user.id, family.id),
      child: Consumer<List<Member>>(
        builder: (context, members, _) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Member member = members.elementAt(index);
                return Container(
                  child: MemberTileWidget(member: member),
                  margin: EdgeInsets.only(top: index <= 0 ? 0.0 : 24.0),
                );
              },
              childCount: members.length,
            ),
          );
        },
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

    return SafeArea(
      child: Material(
        color: AppColors.background,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                appBar,
                priceTile,
                membersList,
              ],
            ),
            floatingActionButton,
          ],
        ),
      ),
    );
  }
}
