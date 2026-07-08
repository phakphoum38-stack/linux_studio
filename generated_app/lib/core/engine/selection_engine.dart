import 'screen_buffer.dart';
import 'terminal_cell.dart';

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

  String extract(dynamic buffer) {
    if (!active) return '';

    final rows =
        buffer is ScreenBuffer
            ? buffer.buffer
            : buffer as List<List<String>>;

    final sb = StringBuffer();

    for (int r = startRow!; r <= endRow!; r++) {
      for (int c = 0; c < rows[r].length; c++) {
        if (r == startRow && c < startCol!) continue;
        if (r == endRow && c > endCol!) continue;

        final cell =
            rows[r][c];

        sb.write(
          cell is String
              ? cell
              : (cell as TerminalCell).char,
        );
      }
      sb.writeln();
    }

    return sb.toString();
  }

  void end() {}

  void clear() {
    startRow = null;
    startCol = null;
    endRow = null;
    endCol = null;
  }
}
