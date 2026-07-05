class Selection {
  int? startRow;
  int? startCol;

  int? endRow;
  int? endCol;

  bool get hasSelection =>
      startRow != null &&
      startCol != null &&
      endRow != null &&
      endCol != null;

  void start(int r, int c) {
    startRow = r;
    startCol = c;
  }

  void update(int r, int c) {
    endRow = r;
    endCol = c;
  }

  void clear() {
    startRow = null;
    startCol = null;
    endRow = null;
    endCol = null;
  }
}
