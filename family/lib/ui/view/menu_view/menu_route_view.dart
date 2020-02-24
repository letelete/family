import 'package:family/core/models/menu_tile.dart';
import 'package:family/ui/shared/gradients.dart';
import 'package:family/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class MenuRouteView extends ModalRoute<void> {
  final List<MenuTile> children;

  MenuRouteView(this.children) : assert(children != null);

  @override
  Duration get transitionDuration => Duration(milliseconds: 450);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  /// We do not want to use a single color for the menu background, we want to have a gradient instead.
  /// To have a gradient background we need to get rid off the barrierColor.
  /// We cannot have it transparent, or null.
  /// Instead we can set its color opacity to such low value, it is going to be slightly noticable.
  @override
  Color get barrierColor => Colors.black.withOpacity(0.01);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.backgroundTransparent),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      ),
      child: Stack(
        children: <Widget>[
          child,
          _animateOverlayContent(context, animation),
        ],
      ),
    );
  }

  Widget _animateOverlayContent(
    BuildContext context,
    Animation<double> animation,
  ) {
    var tween = Tween(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );

    var curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    return SlideTransition(
      position: curvedAnimation.drive(tween),
      child: _getOverlayBody(context),
    );
  }

  Widget _getOverlayBody(BuildContext context) => Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: UiUtils.getSpacedWidgets(
              children: children,
              spacing: SizedBox(height: 32.0),
            ),
          ),
        ),
      );
}
