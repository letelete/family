import 'package:family/ui/view/login_view.dart';
import 'package:flutter/material.dart';

import 'locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: LoginView(),
    );
  }
}