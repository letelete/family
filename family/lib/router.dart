import 'package:family/core/models/family.dart';
import 'package:family/ui/view/family_view/family_view.dart';
import 'package:family/ui/view/home_view/home_view.dart';
import 'package:family/ui/view/login_view.dart';
import 'package:family/ui/view/no_route_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String _noRoutePath = '404';

class Paths {
  static const String loginView = 'login';
  static const String homeView = 'home';
  static const String familyView = '$homeView/family';
}

Map<String, PageRoute> _routes(RouteSettings settings) {
  return {
    _noRoutePath: MaterialPageRoute(builder: (_) => NoRouteView()),
    Paths.homeView: MaterialPageRoute(builder: (_) => HomeView()),
    Paths.loginView: MaterialPageRoute(builder: (_) => LoginView()),
    Paths.familyView: MaterialPageRoute(builder: (_) {
      final family = settings.arguments as Family;
      return FamilyView(family);
    }),
  };
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String routePath = settings.name;
    final routes = _routes(settings);
    String finalPath = routes.containsKey(routePath) ? routePath : _noRoutePath;
    return routes[finalPath];
  }
}
