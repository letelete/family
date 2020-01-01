

import 'package:family/ui/view/login_view.dart';
import 'package:family/ui/view/no_route_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:family/ui/view/home_view.dart';

class Paths {
  static const String baseRoutePath = 'login';
  static const String loginView = 'login';
  static const String homeView = '/';
}

const String _noRoutePath = '404';

Map<String, PageRoute> _routes = {
  Paths.homeView: MaterialPageRoute(builder: (_) => HomeView()),
  Paths.loginView: MaterialPageRoute(builder: (_) => LoginView()),
  _noRoutePath: MaterialPageRoute(builder: (_) => NoRouteView())
};

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String routePath = settings.name;
    String finalPath = _routes.containsKey(routePath) ? routePath : _noRoutePath;
    return _routes[finalPath];
  }
}