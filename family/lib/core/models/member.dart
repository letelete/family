class Member {
  final String name;
  final String photoUrl;
  final bool paid;
  final DateTime nextPayment;

  const Member({
    this.name,
    this.photoUrl,
    this.paid,
    this.nextPayment,
  })  : assert(name != null && name != ''),
        assert(paid != null),
        assert(nextPayment != null);
}
