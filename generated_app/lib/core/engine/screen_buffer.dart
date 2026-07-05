import 'terminal_cell.dart';
import 'cursor.dart';
import 'selection.dart';
import 'utf8_helper.dart';

class ScreenBuffer {
  final int rows;
  final int cols;

  late List<List<TerminalCell>> buffer;

  final Cursor cursor = Cursor();
  final Selection selection = Selection();

  int fg = 7;
  int bg = 0;

  ScreenBuffer({
    required this.rows,
    required this.cols,
  }) {
    buffer = List.generate(
      rows,
      (_) => List.generate(cols, (_) => TerminalCell()),
    );
  }

  void clear() {
    for (final row in buffer) {
      for (final cell in row) {
        cell.reset();
      }
    }

    cursor.reset();
  }

  void write(String text) {
    final chars = Utf8Helper.safeSplit(text);

    for (final ch in chars) {
      _writeChar(ch);
    }
  }

  void _writeChar(String ch) {
    if (ch == '\n') {
      cursor.row++;
      cursor.col = 0;
      return;
    }

    if (cursor.row >= rows) return;

    final cell = buffer[cursor.row][cursor.col];

    cell.char = ch;
    cell.fg = fg;
    cell.bg = bg;

    cursor.col++;

    if (cursor.col >= cols) {
      cursor.col = 0;
      cursor.row++;
    }
  }
}
