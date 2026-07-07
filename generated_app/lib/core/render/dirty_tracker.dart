class DirtyTracker {

  final Set<String> _cells = {};


  Set<String> get dirtyCells => _cells;



  void mark(
    int row,
    int col,
  ) {
    _cells.add(
      '$row:$col',
    );
  }



  void markRow(
    int row,
    int cols,
  ) {

    for (int c = 0; c < cols; c++) {
      mark(row, c);
    }
  }



  void markAll(
    int rows,
    int cols,
  ) {

    for (int r = 0; r < rows; r++) {

      for (int c = 0; c < cols; c++) {

        mark(r, c);
      }
    }
  }



  bool isDirty(
    int row,
    int col,
  ) {

    return _cells.contains(
      '$row:$col',
    );
  }



  void clear() {
    _cells.clear();
  }
}
