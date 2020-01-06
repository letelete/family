class BuildProgress {
  final int lastIndex;
  int currentIndex;

  BuildProgress({this.currentIndex, this.lastIndex})
      : assert(currentIndex >= 0, 'Index must be a positive number'),
        assert(lastIndex >= currentIndex, 'Current index cannot be greater than its limit'),
        assert(currentIndex != null),
        assert(lastIndex != null);

  bool hasReachedEnd() => this.currentIndex >= this.lastIndex;
}
