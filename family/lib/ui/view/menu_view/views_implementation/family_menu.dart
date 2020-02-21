import 'package:family/core/models/family.dart';
import 'package:family/core/models/menu_tile.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/family_menu_model.dart';
import 'package:family/ui/view/menu_view/views_implementation/base_menu.dart';
import 'package:family/ui/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyMenu extends Menu<FamilyMenuModel> {
  final Family family;

  FamilyMenu(BuildContext context, this.family)
      : assert(family != null),
        super(context);

  @override
  List<MenuTile> getChildren(FamilyMenuModel model) {
    final paymentDay = MenuTile(
      title: 'Payment',
      onTap: () {
        //TODO: Open payment builder
      },
    );

    final changeName = MenuTile(
      title: 'Name',
      onTap: () {
        //TODO: Open name builder
      },
    );

    final changePrice = MenuTile(
      title: 'Price',
      onTap: () {
        //TODO: Open price builder
      },
    );

    final removeFamily = MenuTile(
      title: 'Delete',
      onTap: _removeFamily,
    );

    return <MenuTile>[
      paymentDay,
      changeName,
      changePrice,
      removeFamily,
    ];
  }

  void _removeFamily() {
    final user = Provider.of<User>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleAlertDialog(
        title: 'Delete family?',
        description: 'This will permamently delete ${family.name} family',
        confirmingAction: DialogAction(
          label: 'Delete',
          onTap: () {
            model.removeFamily(user.id, family.id);
            close();
          },
        ),
      ),
    );
  }
}
