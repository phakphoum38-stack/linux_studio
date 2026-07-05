class DirtyTracker {
  final Set<String> dirtyCells = {};

  void mark(int row, int col) {
    dirtyCells.add('$row:$col');
  }

  bool isDirty(int row, int col) {
    return dirtyCells.contains('$row:$col');
  }

  void clear() {
    dirtyCells.clear();
  }
}
