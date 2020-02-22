import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/selectable_list_tile.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/widgets/builder_selectable_list.dart';
import 'package:flutter/material.dart';

class MemberSubscriptionDurationPage extends StatelessWidget
    implements BuilderPageContract<MemberBuilderModel> {
  final MemberBuilderModel model;
  final SubscriptionType familySubscription;

  const MemberSubscriptionDurationPage(
    this.model,
    this.familySubscription, {
    Key key,
  }) : super(key: key);

  @override
  String get title => 'How often he needs to pay?';

  @override
  Widget build(BuildContext context) {
    final listTiles = List<SelectableListTile<int>>.generate(4, (i) {
      int duration = i + 1;
      final String periodName = 'month${duration > 1 ? 's' : ''}';
      return SelectableListTile<int>(
          label: '$duration $periodName', value: duration);
    }).toList();

    final passedSubscription = model.member?.subscription;

    int initialSelection = SelectableBuilderListWidget.noSelection;
    if (passedSubscription != null) {
      initialSelection = listTiles.indexWhere((SelectableListTile tile) {
        return tile.value == passedSubscription.tresholdBetweenPayments;
      });
    }

    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
        return SelectableBuilderListWidget<int>(
          children: listTiles,
          onSelected: (duration) => model.onSubscriptionChange(
            duration,
            familySubscription,
          ),
          initialSelection: initialSelection,
        );
      },
    );
  }
}
