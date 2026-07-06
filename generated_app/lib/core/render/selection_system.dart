import '../../engine/screen_buffer.dart';

/// Very small selection system for terminal text.
class SelectionSystem {
  int? startRow;
  int? startCol;
  int? endRow;
  int? endCol;

  void startSelection(int row, int col) {
    startRow = row;
    startCol = col;
    endRow = row;
    endCol = col;
  }

  void updateSelection(int row, int col) {
    endRow = row;
    endCol = col;
  }

  void clear() {
    startRow = null;
    startCol = null;
    endRow = null;
    endCol = null;
  }

  String getSelectedText(ScreenBuffer buffer) {
    if (startRow == null || startCol == null || endRow == null || endCol == null) return '';
    final sr = startRow! < endRow! ? startRow! : endRow!;
    final er = startRow! < endRow! ? endRow! : startRow!;
    final sc = startCol! < endCol! ? startCol! : endCol!;
    final ec = startCol! < endCol! ? endCol! : startCol!;

    final sb = StringBuffer();
    for (var r = sr; r <= er; r++) {
      for (var c = sc; c <= ec; c++) {
        sb.write(buffer.charAt(r, c));
      }
      if (r != er) sb.writeln();
    }
    return sb.toString();
  }
}
