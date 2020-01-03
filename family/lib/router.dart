import 'package:family/ui/view/login_view.dart';
import 'package:family/ui/view/no_route_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:family/ui/view/home_view.dart';

const String _noRoutePath = '404';

class Paths {
  static const String baseRoutePath = 'login';
  static const String loginView = 'login';
  static const String homeView = '/';
}

Map<String, PageRoute> _routes(RouteSettings settings) => {
      _noRoutePath: MaterialPageRoute(builder: (_) => NoRouteView()),
      Paths.homeView: MaterialPageRoute(builder: (_) => HomeView()),
      Paths.loginView: MaterialPageRoute(builder: (_) => LoginView()),
    };

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String routePath = settings.name;

    final routes = _routes(settings);

    String finalPath = routes.containsKey(routePath) ? routePath : _noRoutePath;
    return routes[finalPath];
  }
}
