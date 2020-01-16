import 'dart:convert';

import 'package:family/core/models/member.dart';

const _name = 'name';
const _nextPayment = 'nextPayment';
const _paid = 'paid';
const _photoUrl = 'photoUrl';

class MemberSerializer extends Converter<List, Iterable<Member>> {
  @override
  Iterable<Member> convert(List input) {
    List<Member> members = [];
    if (input == null) {
      print('MemberSerializer: The input is null.');
      return members;
    }

    List membersJsonArray = input.toList();
    if (membersJsonArray.isEmpty) return members;

    try {
      membersJsonArray
          .map((member) => Member(
                name: member[_name],
                nextPayment: member[_nextPayment],
                paid: member[_paid],
                photoUrl: member[_photoUrl],
              ))
          .toList();
    } catch (e) {
      print('MemberSerializer: Error while parsing members. ${e.toString()}');
    }

    return members;
  }
}

extension MemberToJson on Member {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      _name: this.name,
      _nextPayment: this.nextPayment,
      _paid: this.paid.toString(),
      _photoUrl: this.photoUrl,
    };
  }
}
