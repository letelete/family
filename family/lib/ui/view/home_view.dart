import 'package:family/base/base_view.dart';
import 'package:family/core/models/family_card.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/state/view_state.dart';
import 'package:family/core/viewmodels/home_model.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/sizes.dart';
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
          appBar: _getAppBar(user, model),
          floatingActionButton: _getFloatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Column(
            children: <Widget>[
              Visibility(
                visible: model.viewState == ViewState.Busy,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              SizedBox(height: 8.0),
              _getTodayDateText(
                date: model.todayHumanDate,
                parentWidth: parentWidth,
              ),
              SizedBox(height: 8.0),
              Expanded(
                child:
                    model.viewState == ViewState.Idle && model.families.isEmpty
                        ? _noFamiliesPlaceholder()
                        : _getFamilyList(model.families),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getAppBar(User loggedInUser, HomeModel model) => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: AppBarTitle(title: 'My families'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: UserAvatarWidget(
              name: loggedInUser.name,
              photoUrl: loggedInUser.photoUrl,
              size: 40.0,
            ),
          ),
        ],
      );

  Widget _getTodayDateText({String date, double parentWidth}) => Container(
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

  Widget _getFloatingActionButton() => Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 32.0),
        child: FloatingActionButton.extended(
          label: const Text("ADD NEW FAMILY"),
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.primaryAccent,
          onPressed: () {},
        ),
      );
}
