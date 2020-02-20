import 'package:family/core/models/menu_tile.dart';
import 'package:family/core/viewmodels/user_menu_model.dart';
import 'package:family/ui/view/menu_view/views_implementation/base_menu.dart';
import 'package:flutter/material.dart';

class UserMenu extends Menu<UserMenuModel> {
  final BuildContext context;

  UserMenu(this.context);

  @override
  List<MenuTile> getChildren(UserMenuModel model) {
    final logoutMenuTile = MenuTile(
      title: 'Logout',
      onTap: model.logout,
    );

    final cancelMenuTile = MenuTile(
      title: 'Cancel',
      onTap: () => Navigator.pop(context),
    );

    return <MenuTile>[
      logoutMenuTile,
      cancelMenuTile,
    ];
  }
}
