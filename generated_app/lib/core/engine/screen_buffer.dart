import 'cursor_position.dart';
import 'terminal_cell.dart';

class ScreenBuffer {
  final int height;
  final int width;

  late List<List<TerminalCell>> buffer;

  final CursorPosition cursor = CursorPosition();

  int currentForeground = 37;
  int currentBackground = 40;

  bool bold = false;
  bool italic = false;
  bool underline = false;
  bool inverse = false;

  ScreenBuffer({
    this.height = 24,
    this.width = 80,
  }) {
    _init();
  }

  void _init() {
    buffer = List.generate(
      height,
      (_) => List.generate(
        width,
        (_) => TerminalCell(char: ' '),
      ),
    );
  }

  // alias compatibility (IMPORTANT)
  int get rows => height;
  int get cols => width;

  bool _inBounds(int r, int c) =>
      r >= 0 && r < height && c >= 0 && c < width;

  TerminalCell cell(int r, int c) => buffer[r][c];

  // ✔ FIX: fg/bg access required by diff_renderer
  int getFg(int r, int c) => buffer[r][c].fg;
  int getBg(int r, int c) => buffer[r][c].bg;

  // ✔ FIX: setters required
  void setColor(int r, int c, int fg, int bg) {
    if (!_inBounds(r, c)) return;
    buffer[r][c].fg = fg;
    buffer[r][c].bg = bg;
  }

  void write(int r, int c, String ch) {
    if (!_inBounds(r, c)) return;
    buffer[r][c].char = ch;
  }

  void clear() {
    for (var r = 0; r < height; r++) {
      for (var c = 0; c < width; c++) {
        buffer[r][c] = TerminalCell(char: ' ');
      }
    }
  }

  // cursor helpers (minimal needed)
  void moveCursor(int r, int c) {
    cursor.row = r.clamp(0, height - 1);
    cursor.col = c.clamp(0, width - 1);
  }
}
