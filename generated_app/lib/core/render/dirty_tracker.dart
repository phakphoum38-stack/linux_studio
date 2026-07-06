class DirtyTracker {
  final Set<String> dirtyCells = {};

  void mark(int r, int c) {
    dirtyCells.add("$r:$c");
  }

  void clear() {
    dirtyCells.clear();
  }

  bool isDirty(int r, int c) {
    return dirtyCells.contains("$r:$c");
  }
}
