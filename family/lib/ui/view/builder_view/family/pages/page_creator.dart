import 'package:family/builder/base_page_builder.dart';
import 'package:family/core/models/builder/builder_page.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/view/builder_view/family/pages/family_name_page.dart';
import 'package:family/ui/view/builder_view/family/pages/family_price_page.dart';
import 'package:family/ui/view/builder_view/family/pages/family_subscription_type_page.dart';
import 'package:family/ui/view/builder_view/family/pages/famly_payment_day_page.dart';

class FamilyPageCreator extends BasePageCreator<FamilyBuilderModel> {
  final FamilyBuilderModel model;

  const FamilyPageCreator(this.model);

  namePage() {
    final namePage = FamilyNamePage(model);
    return BuilderPageData(
      view: namePage,
      title: namePage.title,
      validated: model.namePageValidated,
    );
  }

  pricePage() {
    final pricePage = FamilyPricePage(model);
    return BuilderPageData(
      view: pricePage,
      title: pricePage.title,
      validated: model.pricePageValidated,
    );
  }

  paymentPage() {
    final paymentDayPage = FamilyPaymentDayPage(model);
    return BuilderPageData(
      view: paymentDayPage,
      title: paymentDayPage.title,
      validated: model.paymentPageValidated,
    );
  }

  subscriptionPage() {
    final subscriptionType = FamilySubscriptionTypePage(model);
    return BuilderPageData(
      view: subscriptionType,
      title: subscriptionType.title,
      validated: model.subscriptionPageValidated,
    );
  }

  @override
  List<BuilderPageData> allPages() => [
        namePage(),
        pricePage(),
        paymentPage(),
        subscriptionPage(),
      ];
}
