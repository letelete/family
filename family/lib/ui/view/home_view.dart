import 'package:family/base/base_view.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/build_data/build_data.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/home_model.dart';
import 'package:family/router.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/view/menu_view/views_implementation/user_menu.dart';
import 'package:family/ui/widgets/app_bar_title_widget.dart';
import 'package:family/ui/widgets/family_card_widget.dart';
import 'package:family/ui/widgets/user_avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const FloatingActionButtonLocation floatingActionButtonLocation =
        FloatingActionButtonLocation.centerFloat;

    final User user = Provider.of<User>(context);
    final double parentWidth = MediaQuery.of(context).size.width;
    final UserMenu userMenu = UserMenu(context);

    return BaseView<HomeModel>(
      onModelReady: (model) => model.fetchTodayDate(),
      builder: (context, model, child) {
        return StreamProvider<List<Family>>.value(
          initialData: const <Family>[],
          value: model.streamFamilies(user.id),
          child: Consumer<List<Family>>(
            builder: (BuildContext context, List<Family> families, _) {
              final appBar = AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.background,
                title: AppBarTitle(title: 'My families'),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: UserAvatarWidget(
                      onTap: () => userMenu.show(),
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
                  onPressed: () =>
                      _showFamilyBuilderForResults(context, model, user.id),
                ),
              );

              final progressIndicator = Visibility(
                visible: model.viewState == ViewState.busy,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
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
                    onTap: (Family family) => Navigator.of(context).pushNamed(
                      Paths.familyView,
                      arguments: family,
                    ),
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
                floatingActionButtonLocation: floatingActionButtonLocation,
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
                        child: model.viewState == ViewState.idle &&
                                families.isEmpty
                            ? familyListPlaceholder
                            : familyList,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showFamilyBuilderForResults(
    BuildContext context,
    HomeModel model,
    String userId,
  ) async {
    final buildData = await Navigator.pushNamed(
      context,
      Paths.familyBuilder,
    ) as BuildData<Family>;
    final BuildResponses response = buildData.response;
    final Family family = buildData.product;
    if (response == BuildResponses.success) {
      await model.addNewFamily(userId, family);
    } else if (response == BuildResponses.error) {
      // TODO: Show error modal
    }
  }
}
