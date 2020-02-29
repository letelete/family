extension StringUtils on String {
  String firstName() {
    final splits = this.split(' ');
    return splits.isNotEmpty ? splits.first : this;
  }
}
