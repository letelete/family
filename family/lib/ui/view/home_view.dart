import 'package:family/base/base_view.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/build_data.dart';
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
    return BaseView<HomeModel>(
      onModelReady: (model) {
        model.fetchFamilies();
        model.fetchTodayDate();
      },
      builder: (context, model, child) {
        final User user = Provider.of<User>(context);
        final double parentWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          backgroundColor: AppColors.background,
          floatingActionButton: _getFloatingActionButton(context, model),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: _getAppBar(context, user, model),
          body: Column(
            children: <Widget>[
              Visibility(
                visible: model.viewState == ViewState.busy,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              SizedBox(height: 8.0),
              _getTodayDateText(model.todayHumanDate, parentWidth),
              SizedBox(height: 8.0),
              Expanded(
                child:
                    model.viewState == ViewState.idle && model.families.isEmpty
                        ? _noFamiliesPlaceholder()
                        : _getFamilyList(model.families),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getAppBar(
    BuildContext context,
    User loggedInUser,
    HomeModel model,
  ) =>
      AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: AppBarTitle(title: 'My families'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: UserAvatarWidget(
              onTap: () {
                final List<MenuTile> menuTiles = _getMenuTiles(context, model);
                return Navigator.of(context).push(
                  MenuRouteView(children: menuTiles),
                );
              },
              name: loggedInUser.name,
              photoUrl: loggedInUser.photoUrl,
              size: 40.0,
            ),
          ),
        ],
      );

  Widget _getTodayDateText(
    String date,
    double parentWidth,
  ) =>
      Container(
        width: parentWidth,
        color: AppColors.homeTodayDateBackground,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          'Today is $date',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Raleway',
            color: AppColors.textSecondary,
            fontSize: TextSizes.appBarSubtitle,
          ),
        ),
      );

  Widget _getFamilyList(List<FamilyCard> families) => ListView.builder(
        itemCount: families.length,
        itemBuilder: (BuildContext context, int position) {
          final FamilyCard familyCard = families.elementAt(position);
          return FamilyCardWidget(familyCard: familyCard);
        },
      );

  Widget _noFamiliesPlaceholder() => Container(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          Assets.generalNotFound,
          semanticsLabel: 'No families added yet',
          width: 190.0,
          height: 130.0,
        ),
      );

  Widget _getFloatingActionButton(
    BuildContext context,
    HomeModel model,
  ) =>
      Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 32.0),
        child: FloatingActionButton.extended(
          label: const Text("ADD NEW FAMILY"),
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.primaryAccent,
          onPressed: () async {
            var data = await Navigator.pushNamed(
              context,
              Paths.familyNameBuilder,
            );

            if (data == null) return;
            if ((data as BuildData).response == BuildResponses.cancel) return;

            BuildData<Family> buildData = data;
            if (buildData.response == BuildResponses.success) {
              
            } else {
              // TODO: Handle error.
            }
          },
        ),
      );

  List<MenuTile> _getMenuTiles(
    BuildContext context,
    HomeModel model,
  ) {
    return <MenuTile>[
      MenuTile(
        title: 'Logout',
        onTap: () async {
          bool sucess = await model.logout();
          if (sucess) {
            return Navigator.pushNamedAndRemoveUntil(
              context,
              Paths.loginView,
              (Route<dynamic> route) => false,
            );
          }
          // TODO: Handle error.
          return null;
        },
      ),
      MenuTile(
        title: 'Cancel',
        onTap: () => Navigator.pop(context),
      )
    ];
  }
}
