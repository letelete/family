import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/core/models/selectable_list_tile.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/widgets/builder_selectable_list.dart';
import 'package:flutter/material.dart';
import 'package:family/ui/utils/string_utils.dart';

class MemberPaidPage extends StatelessWidget
    implements BuilderPageContract<MemberBuilderModel> {
  final MemberBuilderModel model;

  const MemberPaidPage(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  String get title {
    return 'Has ${model.memberName.firstName() ?? 'Member'} paid already?';
  }

  @override
  Widget build(BuildContext context) {
    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
        final children = <SelectableListTile<bool>>[
          SelectableListTile(
            label: '${model.memberName.firstName() ?? 'Member'} paid already',
            value: true,
          ),
          SelectableListTile(
            label: 'No payment yet',
            value: false,
          ),
        ];
        return SelectableBuilderListWidget(
          initialSelection: (model.memberPaid ?? false) ? 0 : 1,
          children: children,
          onSelected: (status) => model.onPaidStatusChange(status),
        );
      },
    );
  }
}
