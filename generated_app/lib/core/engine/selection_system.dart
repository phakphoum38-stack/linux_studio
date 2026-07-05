class SelectionSystem {
  int? startRow, startCol;
  int? endRow, endCol;

  bool get active =>
      startRow != null && endRow != null;

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

  void clear() {
    startRow = startCol = endRow = endCol = null;
  }

  String extract(ScreenBuffer buffer) {
    if (!active) return '';

    final sb = StringBuffer();

    for (int r = startRow!; r <= endRow!; r++) {
      for (int c = startCol!; c <= endCol!; c++) {
        sb.write(buffer.buffer[r][c].char);
      }
      sb.writeln();
    }

    return sb.toString();
  }
}
