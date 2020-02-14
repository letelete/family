/// Describes [Member] basic data neccessary to create its preview on the family card without fetching the complete member data.
class MemberPreview {
  final String id;
  final String photoUrl;
  final DateTime createdAt;

  /// When member has no [photoUrl] set, we want to display its firstname letter.
  final String name;

  const MemberPreview({
    this.id,
    this.photoUrl,
    this.name,
    this.createdAt,
  })  : assert(id != null),
        assert(name != null),
        assert(createdAt != null);
}
