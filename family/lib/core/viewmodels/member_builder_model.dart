import 'package:family/base/base_model.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/build_data/build_data.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/subscripton.dart';

class MemberBuilderModel extends BaseModel {
  BuildData<Member> _buildData;
  bool _validated;
  String _memberName;
  DateTime _memberNextPayment;
  Subscription _memberSubscription;
  String _memberPhotoUrl;

  BuildResponses get buildResponse => _buildData?.response;
  bool get validated => _validated ?? false;
  Member get member => _buildData?.product;
  String get memberName => _memberName;
  DateTime get memberNextPayment => _memberNextPayment;
  Subscription get memberRepaymentDuration => _memberSubscription;
  String get memberPhotoUrl => _memberPhotoUrl;

  void forceValidation(bool validateView, {bool alertState = true}) {
    if (alertState) setState(ViewState.busy);
    this._validated = validateView;
    if (alertState) setState(ViewState.idle);
  }

  void initializeBuildData(BuildData<Member> buildData) {
    this._buildData = buildData;
  }

  bool validateName(String name) {
    this._validated = name != null && name.trim().isNotEmpty;
    setState(ViewState.idle);
    return this._validated;
  }

  void saveName(String name) {
    this._memberName = name.trim();
    setState(ViewState.idle);
  }

  bool validatePaymentDay(DateTime date) {
    this._validated = date != null;
    setState(ViewState.idle);
    return this._validated;
  }

  void savePaymentDay(DateTime date) {
    this._memberNextPayment = date;
    setState(ViewState.idle);
  }

  bool validateSubscription(int treshold, SubscriptionType subscriptionType) {
    this._validated =
        subscriptionType != null && treshold != null && treshold > 0;
    setState(ViewState.idle);
    return this._validated;
  }

  void saveSubscription(int treshold, SubscriptionType subscriptionType) {
    this._memberSubscription = Subscription(
      subscriptionType: subscriptionType,
      tresholdBetweenPayments: treshold,
    );
    setState(ViewState.idle);
  }

  bool validatePhotoUrl(String photoUrl) {
    this._validated = photoUrl != null && photoUrl.trim().isNotEmpty;
    setState(ViewState.idle);
    return this._validated;
  }

  void savePhotoUrl(String photoUrl) {
    this._memberPhotoUrl = photoUrl;
    setState(ViewState.idle);
  }

  void buildMemberFromStoredFields() {
    setState(ViewState.busy);

    final String id = member?.id ?? Member.generateId();
    final String name = memberName ?? member?.name;
    final bool paid = true;
    final String photoUrl = _memberPhotoUrl ?? member?.photoUrl;
    final DateTime nextPaymentDay = _memberNextPayment ?? member?.nextPayment;
    final Subscription subscription =
        _memberSubscription ?? member?.subscription;

    if (id == null ||
        name == null ||
        nextPaymentDay == null ||
        subscription == null) {
      this._buildData = BuildData<Member>(response: BuildResponses.error);
      return;
    }

    final Member newMember = Member(
      id: id,
      name: name,
      paid: paid,
      photoUrl: photoUrl,
      nextPayment: nextPaymentDay,
      subscription: subscription,
    );

    this._buildData = BuildData<Member>(
      product: newMember,
      response: BuildResponses.success,
    );

    setState(ViewState.idle);
  }
}
