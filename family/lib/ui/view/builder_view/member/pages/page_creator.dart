import 'package:family/builder/base_page_builder.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/builder/builder_page.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/view/builder_view/member/pages/member_name_page.dart';
import 'package:family/ui/view/builder_view/member/pages/member_payment_day_page.dart';
import 'package:family/ui/view/builder_view/member/pages/member_subscription_duration.dart';
import 'package:flutter/material.dart';

class MemberPageCreator extends BasePageCreator<MemberBuilderModel> {
  final MemberBuilderModel model;

  const MemberPageCreator(this.model);

  namePage() {
    final namePage = MemberNamePage(model);
    return BuilderPageData(
      view: namePage,
      title: namePage.title,
      validated: model.namePageValidated,
    );
  }

  paymentPage() {
    final paymentDayPage = MemberPaymentDayPage(model);
    return BuilderPageData(
      view: paymentDayPage,
      title: paymentDayPage.title,
      validated: model.paymentPageValidated,
    );
  }

  subscriptionPage(SubscriptionType familySubscription) {
    final subscriptionPage = MemberSubscriptionDurationPage(
      model,
      familySubscription,
    );
    return BuilderPageData(
      view: subscriptionPage,
      title: subscriptionPage.title,
      validated: model.subscriptionPageValidated,
    );
  }

  @override
  List<BuilderPageData> allPages({
    @required SubscriptionType familySubscription,
  }) =>
      [
        namePage(),
        paymentPage(),
        subscriptionPage(familySubscription),
      ];
}
