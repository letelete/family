import 'package:family/base/base_view.dart';
import 'package:family/base/builder/base_builder_view.dart';
import 'package:family/core/models/build_data/build_data.dart';
import 'package:family/core/models/build_data/member_build_data.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/view/builder_view/member/pages/member_name_page.dart';
import 'package:family/ui/view/builder_view/member/pages/member_payment_day_page.dart';
import 'package:family/ui/view/builder_view/member/pages/member_subscription_duration.dart';
import 'package:flutter/material.dart';

class MemberBuilder extends StatelessWidget {
  final MemberBuildData buildData;

  const MemberBuilder({this.buildData})
      : assert(
          buildData != null,
          'Family subscription type cannot be null. Member must belong to existing family.',
        );

  @override
  Widget build(BuildContext context) {
    return BaseView<MemberBuilderModel>(
      onModelReady: (model) {
        if (buildData != null) {
          model.initializeBuildData(buildData);
        }
      },
      builder: (context, model, _) {
        return BaseBuilderView<Member>(
          children: <Widget>[
            MemberNamePage(model),
            MemberPaymentDayPage(model),
            MemberSubscriptionDurationPage(
              model,
              familySubscriptionType: buildData.memberFamilySubscription,
            ),
          ],
          titles: [
            MemberNamePage.title,
            MemberPaymentDayPage.title,
            MemberSubscriptionDurationPage.title
          ],
          nextStepButtonLabel: 'Next',
          finalStepButtonLabel: 'Add member',
          onViewChange: () => model.forceValidation(false, alertState: true),
          viewValidated: model.validated,
          onFinishBuild: () {
            model.buildMemberFromStoredFields();
            return BuildData<Member>(
              product: model.member,
              response: model.buildResponse,
            );
          },
        );
      },
    );
  }
}
