/// Describes [SelectableBuilderListWidget] element.
class SelectableListTile<T> {
  final String label;

  /// The value which tile should hold and return.
  final T value;

  const SelectableListTile({
    this.label,
    this.value,
  }) : assert(label != null && label != '');
}