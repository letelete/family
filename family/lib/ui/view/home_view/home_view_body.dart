import 'package:family/ui/widgets/app_bar_title_widget.dart';
import 'package:family/ui/widgets/user_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/home_model.dart';
import 'package:family/router.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/view/builder_view/family/family_builder.dart';
import 'package:family/ui/view/builder_view/family/pages/page_creator.dart';
import 'package:family/ui/view/menu_view/views_implementation/family_menu.dart';
import 'package:family/ui/view/menu_view/views_implementation/user_menu.dart';
import 'package:family/ui/widgets/family_card_widget.dart';
import 'package:family/ui/widgets/linear_progress_indicator_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeViewBody extends StatelessWidget {
  final HomeModel model;
  final List<Family> families;

  const HomeViewBody(
    this.model,
    this.families, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final parentWidth = MediaQuery.of(context).size.width;

    showFamilyBuilderForResults() async {
      final response = await Navigator.push<BuilderResponse<Family>>(
        context,
        MaterialPageRoute(
          builder: (_) => FamilyBuilder(
            pages: (model) => FamilyPageCreator(model).allPages(),
          ),
        ),
      );
      await model.onFamilyBuilderResponse(user.id, response);
    }

    final appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      title: AppBarTitle(title: 'My families'),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: UserAvatarWidget(
            onTap: () => UserMenu(context).show(),
            name: user.name,
            photoUrl: user.photoUrl,
            size: 40.0,
          ),
        ),
      ],
    );

    final floatingActionButton = Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 32.0),
      child: FloatingActionButton.extended(
        label: const Text("ADD NEW FAMILY"),
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.primaryAccent,
        onPressed: showFamilyBuilderForResults,
      ),
    );

    final progressIndicator = Visibility(
      visible: model.viewState == ViewState.busy,
      child: LinearProgressIndicatorWidget(),
    );

    final dayOfMonthBar = Container(
      width: parentWidth,
      color: AppColors.homeTodayDateBackground,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        'Today is ${model.todayHumanDate}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: AppColors.textSecondary,
          fontSize: TextSizes.appBarSubtitle,
        ),
      ),
    );

    final familyList = ListView.builder(
      itemCount: families.length,
      itemBuilder: (BuildContext context, int position) {
        final Family family = families.elementAt(position);
        return FamilyCardWidget(
          familyCard: FamilyCard.fromFamily(family),
          onTap: (Family family) {
            return Navigator.of(context).pushNamed(
              Paths.familyView,
              arguments: family,
            );
          },
          onLongPress: (Family family) {
            return FamilyMenu(context, family).show();
          },
        );
      },
    );

    final familyListPlaceholder = Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        Assets.generalNotFound,
        semanticsLabel: 'No families added yet',
        width: 190.0,
        height: 130.0,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: appBar,
      body: Column(
        children: <Widget>[
          progressIndicator,
          SizedBox(height: 8.0),
          dayOfMonthBar,
          SizedBox(height: 8.0),
          Expanded(
            flex: 1,
            child: RefreshIndicator(
              onRefresh: () => model.fetchTodayDate(),
              child: model.viewState == ViewState.idle && families.isEmpty
                  ? familyListPlaceholder
                  : familyList,
            ),
          ),
        ],
      ),
    );
  }
}
