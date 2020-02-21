import 'package:family/base/base_model.dart';
import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/enums/view_state.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/member.dart';
import 'package:family/core/models/subscripton.dart';

class MemberBuilderModel extends BaseModel {
  BuilderResponse<Member> _builderResponse;
  Member _member;

  BuilderResponse get builderResponse => _builderResponse;
  Member get member => _member;

  String _memberName;
  DateTime _memberNextPayment;
  Subscription _memberSubscription;
  String _memberPhotoUrl;

  String get memberName => _memberName;
  DateTime get memberNextPayment => _memberNextPayment;
  Subscription get memberRepaymentDuration => _memberSubscription;
  String get memberPhotoUrl => _memberPhotoUrl;

  bool _namePageValidated;
  bool _paymentPageValidated;
  bool _subscriptionPageValidated;
  bool _photoUrlPageValidated;

  bool get namePageValidated => _namePageValidated ?? false;
  bool get paymentPageValidated => _paymentPageValidated ?? false;
  bool get subscriptionPageValidated => _subscriptionPageValidated ?? false;
  bool get photoUrlPageValidated => _photoUrlPageValidated ?? false;

  void initializeMember(Member member) => this._member = member;

  void onNameChange(String name) {
    _namePageValidated = name != null && name.trim().isNotEmpty;
    if (_namePageValidated) {
      _memberName = name.trim();
    }
    setState(ViewState.idle);
  }

  void onPaymentDayChange(DateTime date) {
    _paymentPageValidated = date != null;
    if (paymentPageValidated) {
      _memberNextPayment = date;
    }
    setState(ViewState.idle);
  }

  void onSubscriptionChange(int treshold, SubscriptionType subscriptionType) {
    _subscriptionPageValidated =
        subscriptionType != null && treshold != null && treshold > 0;
    if (subscriptionPageValidated) {
      _memberSubscription = Subscription(
        subscriptionType: subscriptionType,
        tresholdBetweenPayments: treshold,
      );
    }
    setState(ViewState.idle);
  }

  void onPhotoUrlChange(String photoUrl) {
    _photoUrlPageValidated = photoUrl != null && photoUrl.trim().isNotEmpty;
    if (photoUrlPageValidated) {
      _memberPhotoUrl = photoUrl;
    }
    setState(ViewState.idle);
  }

  void buildMemberFromStoredFields() {
    setState(ViewState.busy);
    final String id = member?.id ?? Member.generateId();
    final String name = memberName ?? member?.name;
    final bool paid = member?.paid ?? true;
    final String photoUrl = _memberPhotoUrl ?? member?.photoUrl;
    final DateTime nextPaymentDay = _memberNextPayment ?? member?.nextPayment;
    final Subscription subscription =
        _memberSubscription ?? member?.subscription;
    final DateTime createdAt = member?.createdAt ?? DateTime.now();

    Member newMember;
    BuildResponse response = BuildResponse.success;
    try {
      newMember = Member(
        id: id,
        name: name,
        paid: paid,
        photoUrl: photoUrl,
        nextPayment: nextPaymentDay,
        subscription: subscription,
        createdAt: createdAt,
      );
    } catch (error) {
      print('Couldn\'t build a member $error');
      response = BuildResponse.error;
    }

    this._builderResponse = BuilderResponse<Member>(
      product: newMember,
      response: response,
    );
    setState(ViewState.idle);
  }
}
