import 'package:family/ui/shared/gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressBar(),
      child: Consumer<ProgressBar>(
        builder: (_, progressBar, __) => Scaffold(
          body: InkWell(
            onLongPress: () => progressBar.hide(),
            onTap: () => progressBar.show(),
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
                    visible: progressBar.isVisible,
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
