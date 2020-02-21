import 'package:family/builder/builder_contract.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/models/builder/build_data.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/builder/builder_page.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/menu_tile.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/family_menu_model.dart';
import 'package:family/ui/view/builder_view/family/family_builder.dart';
import 'package:family/ui/view/builder_view/family/pages/page_creator.dart';
import 'package:family/ui/view/menu_view/views_implementation/base_menu.dart';
import 'package:family/ui/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyMenu extends Menu<FamilyMenuModel> {
  Family family;

  FamilyMenu(BuildContext context, this.family)
      : assert(family != null),
        super(context);

  @override
  List<MenuTile> getChildren(FamilyMenuModel model) {
    final changeName = MenuTile(
      title: 'Name',
      onTap: () async => _createAndShowBuilder(
        (model) => FamilyPageCreator(model).namePage(),
      ),
    );

    final changePrice = MenuTile(
      title: 'Price',
      onTap: () async => _createAndShowBuilder(
        (model) => FamilyPageCreator(model).pricePage(),
      ),
    );

    final paymentDay = MenuTile(
      title: 'Payment',
      onTap: () async => _createAndShowBuilder(
        (model) => FamilyPageCreator(model).paymentPage(),
      ),
    );

    final deleteFamily = MenuTile(
      title: 'Delete',
      onTap: _showDeleteFamilyDialog,
    );

    return <MenuTile>[
      paymentDay,
      changeName,
      changePrice,
      deleteFamily,
    ];
  }

  Future<void> _createAndShowBuilder(
    BuilderPageData Function(FamilyBuilderModel model) page,
  ) async {
    final builder = FamilyBuilder(
      finalStepButtonLabel: BuilderContract.defaultUpdateLabel,
      pages: (model) => <BuilderPageData>[page(model)],
      initialData: BuilderInitialData<Family>(product: family),
    );
    return await _showBuilderForResults(builder);
  }

  Future<void> _showBuilderForResults(FamilyBuilder builder) async {
    final data = await Navigator.push<BuilderResponse<Family>>(
        context, MaterialPageRoute(builder: (_) => builder));
    if (data?.response == BuildResponse.success) {
      final user = Provider.of<User>(context, listen: false);
      this.family = data.product;
      model.updateUserFamily(user.id, family);
    }
  }

  Future<void> _showDeleteFamilyDialog() async {
    final user = Provider.of<User>(context, listen: false);
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleAlertDialog(
        title: 'Delete family?',
        description: 'This will permamently delete ${family.name} family',
        confirmingAction: DialogAction(
          label: 'Delete',
          onTap: () {
            model.deleteFamily(user.id, family.id);
            close();
          },
        ),
      ),
    );
  }
}
