import 'package:family/base/base_view.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/viewmodels/login_model.dart';
import 'package:family/ui/shared/assets.dart';
import 'package:family/ui/shared/gradients.dart';
import 'package:family/ui/widgets/linear_progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      onModelReady: (model) => model.login(),
      builder: (context, model, child) {
        final Widget backgroundIllustration = Expanded(
          child: SvgPicture.asset(
            Assets.loginPageIllustration,
            semanticsLabel: 'Login page illustration',
            width: 250.0,
            height: 250.0,
          ),
        );

        final Widget connectWithGoogleLabel = Container(
          margin: EdgeInsets.only(bottom: 32.0),
          child: Text(
            'Connect with google to continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );

        final Widget authProgressIndicator = Visibility(
          visible: model.viewState == ViewState.busy,
          child: LinearProgressIndicatorWidget(),
        );

        final Widget bodyContainer = Container(
          decoration: BoxDecoration(gradient: AppGradients.backgroundSolid),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              backgroundIllustration,
              connectWithGoogleLabel,
              authProgressIndicator,
            ],
          ),
        );

        return MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: model.login,
                  child: bodyContainer,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
