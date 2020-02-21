import 'package:family/base/base_model.dart';
import 'package:family/core/models/menu_tile.dart';
import 'package:family/locator.dart';
import 'package:family/ui/view/menu_view/menu_route_view.dart';
import 'package:flutter/cupertino.dart';

abstract class Menu<T extends BaseModel> {
  final T model = locator<T>();
  final BuildContext context;

  Menu(this.context);

  List<MenuTile> getChildren(T model);

  Future<void> show() async {
    List<MenuTile> children = getChildren(model);
    children.add(_cancelMenuTile());
    await Navigator.of(context).push(MenuRouteView(children));
  }

  MenuTile _cancelMenuTile() => MenuTile(
        title: 'Cancel',
        onTap: close,
      );

  void close() => Navigator.of(context).pop();
}
