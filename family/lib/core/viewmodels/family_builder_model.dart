import 'package:family/base/base_model.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/member_preview.dart';
import 'package:family/core/models/price.dart';

class FamilyBuilderModel extends BaseModel {
  BuilderResponse<Family> _builderResponse;
  Family _family;
  Price _price;
  String _name;
  DateTime _paymentDay;
  SubscriptionType _subscriptionType;

  bool _namePageValidated;
  bool _pricePageValidated;
  bool _paymentPageValidated;
  bool _subscriptionPageValidated;

  BuilderResponse<Family> get buildResponse => _builderResponse;
  Family get family => _family;
  Price get price => _price ?? family?.price;
  String get name => _name ?? family?.name;
  DateTime get paymentDay => _paymentDay ?? family?.paymentDay;
  SubscriptionType get subscriptionType =>
      _subscriptionType ?? family?.subscriptionType;

  bool get namePageValidated => _namePageValidated ?? false;
  bool get pricePageValidated => _pricePageValidated ?? false;
  bool get paymentPageValidated => _paymentPageValidated ?? false;
  bool get subscriptionPageValidated => _subscriptionPageValidated ?? false;

  void initializeFamily(Family family) => _family = family;

  void onNameChange(String name) {
    _namePageValidated = name != null && name.trim().isNotEmpty;
    if (namePageValidated) {
      _name = name;
    }
    setState(ViewState.idle);
  }

  void onPriceChange(String price, String currency) {
    _pricePageValidated = price != null &&
        price.trim().isNotEmpty &&
        currency != null &&
        currency.trim().isNotEmpty;
    if (pricePageValidated) {
      _price = Price.fromRaw(
        priceLine: price,
        currency: currency,
      );
    }
    setState(ViewState.idle);
  }

  void onSubscriptionChange(dynamic subscriptionType) {
    _subscriptionPageValidated = subscriptionType != null;
    if (subscriptionPageValidated) {
      _subscriptionType = subscriptionType as SubscriptionType;
    }
    setState(ViewState.idle);
  }

  void onPaymentDayChange(DateTime paymentDay) {
    _paymentPageValidated = paymentDay != null;
    if (paymentPageValidated) {
      _paymentDay = paymentDay;
    }
    setState(ViewState.idle);
  }

  void buildFamilyFromStoredFields() {
    final String id = this.family?.id ?? Family.generateId();
    final String name = this.name;
    final DateTime paymentDay = this.paymentDay;
    final Price price = this.price;
    final SubscriptionType subscriptionType = this.subscriptionType;
    final List<MemberPreview> membersPreview =
        this.family?.membersPreview ?? [];

    Family newFamily;
    BuildResponse response = BuildResponse.success;
    try {
      newFamily = Family(
        id: id,
        name: name,
        paymentDay: paymentDay,
        price: price,
        subscriptionType: subscriptionType,
        membersPreview: membersPreview,
      );
    } catch (error) {
      print('Couldn\'t build a family $error');
      response = BuildResponse.error;
    }

    _builderResponse = BuilderResponse<Family>(
      product: newFamily,
      response: response,
    );
    setState(ViewState.idle);
  }
}
