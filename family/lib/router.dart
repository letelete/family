import 'package:family/core/models/build_data/build_data.dart';
import 'package:family/core/models/build_data/member_build_data.dart';
import 'package:family/core/models/family.dart';
import 'package:family/ui/view/builder_view/family/family_builder.dart';
import 'package:family/ui/view/builder_view/member/member_builder.dart';
import 'package:family/ui/view/family_view.dart';
import 'package:family/ui/view/login_view.dart';
import 'package:family/ui/view/no_route_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:family/ui/view/home_view.dart';

const String _noRoutePath = '404';

class Paths {
  static const String loginView = 'login';
  static const String homeView = 'home';
  static const String familyView = '$homeView/family';
  static const String familyBuilder = '$homeView/familyBuilder';
  static const String memberBuilder = '$familyView/memberBuilder';
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
    Paths.familyBuilder: MaterialPageRoute(builder: (_) {
      final familyBuildData = settings.arguments as BuildData<Family>;
      return FamilyBuilder(buildData: familyBuildData);
    }),
    Paths.memberBuilder: MaterialPageRoute(builder: (_) {
      final memberBuildData = settings.arguments as MemberBuildData;
      return MemberBuilder(buildData: memberBuildData);
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
