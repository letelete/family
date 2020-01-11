import 'package:family/base/base_model.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/build_data.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/price.dart';

class FamilyBuilderModel extends BaseModel {
  BuildData<Family> _buildData;
  Price _price;
  String _name;
  DateTime _paymentDay;
  SubscriptionType _subscriptionType;
  bool _validated = false;

  Family get family => this._buildData?.product;

  BuildResponses get buildResponse => this._buildData?.response;

  Price get price => this._price;

  String get name => this._name;

  DateTime get paymentDay => this._paymentDay;

  SubscriptionType get subscriptionType => this._subscriptionType;

  bool get isViewValidated => this._validated;

  void forceValidation(bool validateView, {bool alertState = true}) {
    if (alertState) setState(ViewState.busy);
    this._validated = validateView;
    if (alertState) setState(ViewState.idle);
  }

  void initializeBuildData(BuildData<Family> buildData) {
    this._buildData = buildData;
  }

  void validateNameAndSave(String name) {
    setState(ViewState.busy);

    this._validated = name != null && name.trim().isNotEmpty;
    if (this._validated) {
      this._name = name;
    }

    setState(ViewState.idle);
  }

  void validatePriceAndSave(String price, String currency) {
    setState(ViewState.busy);

    this._validated = price != null &&
        price.trim().isNotEmpty &&
        currency != null &&
        currency.trim().isNotEmpty;

    if (this._validated) {
      this._price = Price.fromRaw(
        priceLine: price,
        currency: currency,
      );
    }

    setState(ViewState.idle);
  }

  void validatePaymentDayAndSave(DateTime paymentDay) {
    setState(ViewState.busy);

    this._validated = paymentDay != null;
    if (this._validated) {
      this._paymentDay = paymentDay;
    }

    setState(ViewState.idle);
  }

  void validateSubscriptionTypeAndSave(dynamic subscriptionType) {
    setState(ViewState.busy);

    this._validated = subscriptionType != null;
    if (this._validated) {
      this._subscriptionType = subscriptionType as SubscriptionType;
    }

    setState(ViewState.idle);
  }

  void buildFamilyFromStoredFields() {
    setState(ViewState.busy);

    final String id = this.family?.id ?? Family.generateId();
    final String name =
        this._name != null ? Family.formatName(this._name) : this.family?.name;
    final DateTime paymentDay = this._paymentDay ?? this.family?.paymentDay;
    final Price price = this._price ?? this.family?.price;
    final SubscriptionType subscriptionType =
        this._subscriptionType ?? this.family?.subscriptionType;
    final List<Member> members = this.family?.members ?? <Member>[];

    if (id == null ||
        name == null ||
        paymentDay == null ||
        price == null ||
        subscriptionType == null) {
      this._buildData = BuildData<Family>(response: BuildResponses.error);
      return;
    }

    final Family newFamily = Family(
      id: id,
      name: name,
      paymentDay: paymentDay,
      price: price,
      subscriptionType: subscriptionType,
      members: members,
    );

    this._buildData = BuildData<Family>(
      product: newFamily,
      response: BuildResponses.success,
    );

    setState(ViewState.idle);
  }
}
