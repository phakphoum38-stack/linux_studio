class ScreenDiffManager {
  final List<List<String>> previous = [];
  final List<List<String>> current = [];

  final Set<int> dirtyRows = {};

  void updateCell(int row, int col, String value) {
    current[row][col] = value;
    dirtyRows.add(row);
  }

  bool isDirty(int row) => dirtyRows.contains(row);

  void clearDirty() => dirtyRows.clear();
}
