class SelectionEngine {
  int? startRow;
  int? startCol;

  int? endRow;
  int? endCol;

  void start(int r, int c) {
    startRow = r;
    startCol = c;
    endRow = r;
    endCol = c;
  }

  void update(int r, int c) {
    endRow = r;
    endCol = c;
  }

  bool get active =>
      startRow != null &&
      endRow != null &&
      startCol != null &&
      endCol != null;

  String extract(List<List<String>> buffer) {
    if (!active) return '';

    final sb = StringBuffer();

    for (int r = startRow!; r <= endRow!; r++) {
      for (int c = 0; c < buffer[r].length; c++) {
        if (r == startRow && c < startCol!) continue;
        if (r == endRow && c > endCol!) continue;

        sb.write(buffer[r][c]);
      }
      sb.writeln();
    }

    return sb.toString();
  }

  void clear() {
    startRow = null;
    startCol = null;
    endRow = null;
    endCol = null;
  }
}
