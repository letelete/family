import 'package:family/base/base_view.dart';
import 'package:family/base/builder/base_builder_view.dart';
import 'package:family/core/models/build_data/build_data.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/view/builder_view/family/pages/family_name_page.dart';
import 'package:family/ui/view/builder_view/family/pages/family_price_page.dart';
import 'package:family/ui/view/builder_view/family/pages/family_subscription_type_page.dart';
import 'package:family/ui/view/builder_view/family/pages/famly_payment_day_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FamilyBuilder extends StatelessWidget {
  final BuildData<Family> buildData;

  const FamilyBuilder({this.buildData});

  @override
  Widget build(BuildContext context) {
    return BaseView<FamilyBuilderModel>(
      onModelReady: (model) {
        if (buildData != null) {
          model.initializeBuildData(buildData);
        }
      },
      builder: (context, model, _) {
        return BaseBuilderView<Family>(
          children: <Widget>[
            FamilyNamePage(model: model),
            FamilyPricePage(model: model),
            FamilyPaymentDayPage(model: model),
            FamilySubscriptionTypePage(model: model),
          ],
          titles: const <String>[
            FamilyNamePage.title,
            FamilyPricePage.title,
            FamilyPaymentDayPage.title,
            FamilySubscriptionTypePage.title,
          ],
          nextStepButtonLabel: 'Next',
          finalStepButtonLabel: 'Create',
          viewValidated: model.isViewValidated,
          onViewChange: () {
            print('view changed');
            return model.forceValidation(false, alertState: true);
          },
          onFinishBuild: () {
            model.buildFamilyFromStoredFields();
            return BuildData<Family>(
              product: model.family,
              response: model.buildResponse,
            );
          },
        );
      },
    );
  }
}
