import 'package:family/base/base_view.dart';
import 'package:family/core/viewmodels/no_route_model.dart';
import 'package:family/router.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/gradients.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoRouteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<NoRouteModel>(
      onModelReady: (model) async {
        bool redirect = await model.redirectToHomeScreen();
        if (redirect) {
          Navigator.pushNamed(context, Paths.homeView);
        }
      },
      builder: (context, model, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppGradients.backgroundSolid),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  Assets.generalNotFound,
                  semanticsLabel: 'Route not found',
                  width: 190.0,
                  height: 130.0,
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 32.0),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Sorry! An error occured while oppening this page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TextSizes.placeholderTitle,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                child: Text(
                  'Redirecting to the home page in ${model.redirectionTimeout.inSeconds}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TextSizes.placeholderSubtitle,
                    color: AppColors.textSecondary,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
