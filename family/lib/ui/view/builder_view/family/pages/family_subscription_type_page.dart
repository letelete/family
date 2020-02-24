import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/selectable_list_tile.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/widgets/builder_selectable_list.dart';
import 'package:flutter/material.dart';

class FamilySubscriptionTypePage extends StatelessWidget
    implements BuilderPageContract<FamilyBuilderModel> {
  final FamilyBuilderModel model;

  const FamilySubscriptionTypePage(this.model, {Key key}) : super(key: key);

  @override
  String get title => 'How often do you pay?';

  @override
  Widget build(BuildContext context) {
    const listTiles = <SelectableListTile<SubscriptionType>>[
      SelectableListTile(label: 'Weekly', value: SubscriptionType.weekly),
      SelectableListTile(label: 'Monthly', value: SubscriptionType.monthly),
      SelectableListTile(label: 'Yearly', value: SubscriptionType.yearly),
    ];

    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
        final passedSubscriptionType = model.family?.subscriptionType;

        int initialSelection = SelectableBuilderListWidget.noSelection;
        if (passedSubscriptionType != null) {
          initialSelection = listTiles.indexWhere((SelectableListTile tile) {
            return tile.value == passedSubscriptionType;
          });
        }

        return SelectableBuilderListWidget<SubscriptionType>(
          children: listTiles,
          onSelected: model.onSubscriptionChange,
          initialSelection: initialSelection,
        );
      },
    );
  }
}
