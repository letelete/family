/// Describes [Member] basic data neccessary to create its preview on the family card without fetching the complete member data.
class MemberPreview {
  final String id;

  /// When member has no [photoUrl] set, we want to display its firstname letter.
  final String name;

  final String photoUrl;

  const MemberPreview({this.id, this.photoUrl, this.name})
      : assert(id != null),
        assert(name != null);
}
