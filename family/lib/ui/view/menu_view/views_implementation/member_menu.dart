import 'package:family/builder/builder_contract.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/models/builder/build_data.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/builder/builder_page.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/menu_tile.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/core/viewmodels/member_menu_model.dart';
import 'package:family/ui/view/builder_view/member/member_builder.dart';
import 'package:family/ui/view/builder_view/member/pages/page_creator.dart';
import 'package:family/ui/view/menu_view/views_implementation/base_menu.dart';
import 'package:family/ui/widgets/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberMenu extends Menu<MemberMenuModel> {
  final Family memberFamily;
  Member member;

  MemberMenu(
    BuildContext context,
    this.member,
    this.memberFamily,
  )   : assert(member != null),
        super(context);

  @override
  List<MenuTile> getChildren(MemberMenuModel model) {
    final paymentDay = MenuTile(
      title: 'Payment day',
      onTap: () async => _createAndShowBuilder(
        (model) => MemberPageCreator(model).paymentPage(),
      ),
    );

    final subscription = MenuTile(
      title: 'Subscription',
      onTap: () async => _createAndShowBuilder(
        (model) => MemberPageCreator(model)
            .subscriptionPage(member.subscription.subscriptionType),
      ),
    );

    final name = MenuTile(
      title: 'Name',
      onTap: () async => _createAndShowBuilder(
        (model) => MemberPageCreator(model).namePage(),
      ),
    );

    final deleteMember = MenuTile(
      title: 'Delete',
      onTap: _showDeleteMemberDialog,
    );

    return <MenuTile>[
      paymentDay,
      subscription,
      name,
      deleteMember,
    ];
  }

  Future<void> _createAndShowBuilder(
    BuilderPageData Function(MemberBuilderModel model) page,
  ) async {
    final builder = MemberBuilder(
      finalStepButtonLabel: BuilderContract.defaultUpdateLabel,
      pages: (model) => <BuilderPageData>[page(model)],
      initialData: BuilderInitialData<Member>(product: member),
    );
    await _showBuilderForResults(builder);
  }

  Future<void> _showBuilderForResults(MemberBuilder builder) async {
    final data = await Navigator.push<BuilderResponse<Member>>(
        context, MaterialPageRoute(builder: (_) => builder));
    if (data?.response == BuildResponse.success) {
      final user = Provider.of<User>(context, listen: false);
      this.member = data.product;
      await model.updateMember(user.id, memberFamily.id, member);
    }
  }

  Future<void> _showDeleteMemberDialog() async {
    final user = Provider.of<User>(context, listen: false);
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleAlertDialog(
        title: 'Delete member?',
        description:
            'This will permamently remove ${member.name} from this family',
        confirmingAction: DialogAction(
          label: 'Delete',
          onTap: () {
            model.deleteMember(user.id, memberFamily.id, member.id);
            close();
          },
        ),
      ),
    );
  }
}
