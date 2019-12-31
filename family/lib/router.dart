

import 'package:family/ui/view/login_view.dart';
import 'package:family/ui/view/no_route_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:family/ui/view/home_view.dart';

const String baseRoutePath = 'login';

const String _noRoutePath = '404';

Map<String, PageRoute> routes = {
  '/': MaterialPageRoute(builder: (_) => HomeView()),
  'login': MaterialPageRoute(builder: (_) => LoginView()),
   _noRoutePath: MaterialPageRoute(builder: (_) => NoRouteView())
};

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String routePath = settings.name;
    String finalPath = routes.containsKey(routePath) ? routePath : _noRoutePath;
    return routes[finalPath];
  }
}