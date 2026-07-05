class SelectionController {
  int? startRow;
  int? startCol;

  int? endRow;
  int? endCol;

  bool get active =>
      startRow != null &&
      startCol != null &&
      endRow != null &&
      endCol != null;

  void begin(int r, int c) {
    startRow = r;
    startCol = c;
    endRow = r;
    endCol = c;
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
