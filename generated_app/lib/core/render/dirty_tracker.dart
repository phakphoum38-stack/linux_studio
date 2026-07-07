class DirtyTracker {
  final Set<String> _dirtyCells = {};

  /// Current dirty cells
  Set<String> get dirtyCells =>
      Set.unmodifiable(_dirtyCells);

  /// Mark one cell dirty
  void mark(
    int row,
    int col,
  ) {
    _dirtyCells.add('$row:$col');
  }

  /// Mark entire row dirty
  void markRow(
    int row, {
    int cols = 80,
  }) {
    for (int col = 0; col < cols; col++) {
      mark(row, col);
    }
  }

  /// Mark whole terminal dirty
  void markAll({
    int rows = 24,
    int cols = 80,
  }) {
    for (int row = 0; row < rows; row++) {
      markRow(
        row,
        cols: cols,
      );
    }
  }

  /// Remove all dirty state
  void clear() {
    _dirtyCells.clear();
  }

  /// Check cell state
  bool isDirty(
    int row,
    int col,
  ) {
    return _dirtyCells.contains(
      '$row:$col',
    );
  }

  /// Number of dirty cells
  int get count =>
      _dirtyCells.length;
}
