import 'package:family/base/base_view.dart';
import 'package:family/core/state/view_state.dart';
import 'package:family/core/viewmodels/login_model.dart';
import 'package:family/router.dart';
import 'package:family/ui/shared/gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      builder: (context, model, child) =>
     Scaffold(
          body: InkWell(
            onTap: () async {
              bool success = await model.login();
              if (success) {
                Navigator.pushNamed(context, Paths.homeView);
              }
            },
            child: Container(
              decoration: BoxDecoration(gradient: AppGradientBackground.solid),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: SvgPicture.asset(
                      'assets/illustration_login_page.svg',
                      semanticsLabel: 'Login page illustration',
                      width: 250.0,
                      height: 250.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 32.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Connect with google to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: model.viewState == ViewState.Busy,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.black,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

class ProgressBar with ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners();
    }
  }
}
