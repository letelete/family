import 'package:family/core/services/authentication_service.dart';
import 'package:family/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/models/user.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
        initialData: User.initial(),
        create: (BuildContext context) =>
            locator<AuthenticationService>().userController.stream,
        child: MaterialApp(
          title: 'Family',
          theme: ThemeData(
            fontFamily: 'Roboto',
          ),
          initialRoute: Paths.baseRoutePath,
          onGenerateRoute: Router.generateRoute,
        ));
  }
}
