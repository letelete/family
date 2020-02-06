import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/enums/subscription_type.dart';
import 'package:family/core/models/build_data/build_data.dart';
import 'package:family/core/models/member.dart';
import 'package:flutter/material.dart';

class MemberBuildData extends BuildData<Member> {
  final SubscriptionType memberFamilySubscription;

  const MemberBuildData({
    Member product,
    BuildResponses response,
    @required this.memberFamilySubscription,
  }) : super(product: product, response: response);
}
