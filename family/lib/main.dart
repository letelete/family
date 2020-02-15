import 'package:family/core/services/authentication_service.dart';
import 'package:family/router.dart';
import 'package:family/ui/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/models/user.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(Family());
}

class Family extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationService _auth = locator<AuthenticationService>();
    return StreamProvider<User>.value(
      initialData: null,
      value: _auth.userController.stream,
      child: Consumer<User>(
        builder: (BuildContext context, User user, _) {
          print('User: ${user.toString()}');
          bool userNotAuthenticated = user == null;
          return userNotAuthenticated
              ? LoginView()
              : MaterialApp(
                  title: 'Family',
                  theme: ThemeData(fontFamily: 'Roboto'),
                  initialRoute: Paths.homeView,
                  onGenerateRoute: Router.generateRoute,
                );
        },
      ),
    );
  }
}
