import 'package:family/base/builder/base_page_view.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/selectable_list_tile.dart';
import 'package:family/core/models/subscripton.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/widgets/builder_selectable_list.dart';
import 'package:flutter/material.dart';

class MemberSubscriptionDurationPage extends StatelessWidget {
  static const String title = 'How often he needs to pay?';

  final MemberBuilderModel model;
  final SubscriptionType familySubscriptionType;

  const MemberSubscriptionDurationPage(
    this.model, {
    Key key,
    @required this.familySubscriptionType,
  })  : assert(model != null),
        assert(familySubscriptionType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final listTiles = List<SelectableListTile<int>>.generate(4, (i) {
      int duration = i + 1;
      final String periodName = 'month${duration > 1 ? 's' : ''}';
      return SelectableListTile<int>(
          label: '$duration $periodName', value: duration);
    }).toList();

    final Subscription givenSusbcription = model.member?.subscription;

    int initialSelection = SelectableBuilderListWidget.noSelection;
    if (givenSusbcription != null) {
      initialSelection = listTiles.indexWhere((SelectableListTile tile) {
        return tile.value == givenSusbcription.tresholdBetweenPayments;
      });
    }

    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
        return SelectableBuilderListWidget<int>(
          children: listTiles,
          onSelected: (duration) {
            bool isDurationValid =
                model.validateSubscription(duration, familySubscriptionType);
            if (isDurationValid) {
              model.saveSubscription(duration, familySubscriptionType);
            }
          },
          initialSelection: initialSelection,
        );
      },
    );
  }
}
