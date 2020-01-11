import 'package:family/base/builder/base_page_view.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/selectable_list_tile.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/widgets/builder_selectable_list.dart';
import 'package:flutter/material.dart';

class FamilySubscriptionTypePage extends StatelessWidget {
  static const String title = 'How often do you pay?';

  final FamilyBuilderModel model;

  const FamilySubscriptionTypePage({
    Key key,
    this.model,
  })  : assert(model != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBuilderPageView<FamilyBuilderModel>(builder: (context) {
      const listTiles = const <SelectableListTile<SubscriptionType>>[
        SelectableListTile(label: 'Weekly', value: SubscriptionType.weekly),
        SelectableListTile(label: 'Monthly', value: SubscriptionType.monthly),
        SelectableListTile(label: 'Yearly', value: SubscriptionType.yearly),
      ];

      final SubscriptionType passedSubscriptionType =
          model.family?.subscriptionType;

      int initialSelection = SelectableBuilderListWidget.noSelection;
      if (passedSubscriptionType != null) {
        initialSelection = listTiles.indexWhere((SelectableListTile tile) {
          return tile.value == passedSubscriptionType;
        });
      }

      return SelectableBuilderListWidget<SubscriptionType>(
        children: listTiles,
        onSelected: model.validateSubscriptionTypeAndSave,
        initialSelection: initialSelection,
      );
    });
  }
}
