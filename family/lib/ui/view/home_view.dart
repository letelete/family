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
import 'package:family/ui/view/menu_view.dart';
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

    return BaseView<HomeModel>(
      onModelReady: (model) {
        model.fetchTodayDate();
      },
      builder: (context, model, child) {
        return StreamProvider<List<Family>>.value(
          value: model.streamFamilies(user.id),
          child: Consumer<List<Family>>(
            builder: (BuildContext context, List<Family> families, _) {
              final List<Family> families = Provider.of<List<Family>>(context);

              Widget logoutMenuTile = MenuTile(
                title: 'Logout',
                onTap: () => _logout(context, model),
              );

              Widget cancelMenuTile = MenuTile(
                title: 'Cancel',
                onTap: () => Navigator.pop(context),
              );

              List<MenuTile> menuTiles = <MenuTile>[
                logoutMenuTile,
                cancelMenuTile,
              ];

              Widget appBar = AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.background,
                title: AppBarTitle(title: 'My families'),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: UserAvatarWidget(
                      onTap: () {
                        return Navigator.of(context).push(
                          MenuRouteView(children: menuTiles),
                        );
                      },
                      name: user.name,
                      photoUrl: user.photoUrl,
                      size: 40.0,
                    ),
                  ),
                ],
              );

              Widget floatingActionButton = Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 32.0),
                child: FloatingActionButton.extended(
                  label: const Text("ADD NEW FAMILY"),
                  foregroundColor: AppColors.textPrimary,
                  backgroundColor: AppColors.primaryAccent,
                  onPressed: () {
                    return _showFamilyBuilderForResults(
                        context, model, user.id);
                  },
                ),
              );

              Widget progressIndicator = Visibility(
                visible: model.viewState == ViewState.busy,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );

              Widget dayOfMonthBar = Container(
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

              Widget familyList = ListView.builder(
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

              Widget familyListPlaceholder = Container(
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
                      child:
                          model.viewState == ViewState.idle && families.isEmpty
                              ? familyListPlaceholder
                              : familyList,
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
    final data = await Navigator.pushNamed(
      context,
      Paths.familyBuilder,
    );
    BuildData<Family> buildData = data as BuildData<Family>;
    bool noNeedToUpdateView =
        buildData == null || buildData.response == BuildResponses.cancel;
    if (noNeedToUpdateView) return;

    Family family = buildData.product;
    if (buildData.response == BuildResponses.success) {
      bool error = !await model.addNewFamily(userId, family);
      if (error) print('Error adding new family: ${family.toString()}');
    } else {
      print('BuildData has unsuccessful response: ${buildData.toString()}');
    }
  }

  Future<void> _logout(BuildContext context, HomeModel model) async {
    bool sucess = await model.logout();
    if (sucess) {
      print('Successfully logged-out :)');
    } else {
      print('Error logging-out from the app');
    }
  }
}
