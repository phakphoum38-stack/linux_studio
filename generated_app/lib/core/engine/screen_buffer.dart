import 'cursor.dart';

class TerminalCell {
  TerminalCell({
    this.char = ' ',
    this.foreground = 37,
    this.background = 40,
    this.bold = false,
    this.underline = false,
    this.inverse = false,
  });

  String char;

  int foreground;
  int background;

  bool bold;
  bool underline;
  bool inverse;

  TerminalCell copy() {
    return TerminalCell(
      char: char,
      foreground: foreground,
      background: background,
      bold: bold,
      underline: underline,
      inverse: inverse,
    );
  }
}

class ScreenBuffer {
  ScreenBuffer({
    this.rows = 24,
    this.cols = 80,
    this.maxScrollback = 10000,
  }) {
    _allocate();
  }

  final int maxScrollback;

  int rows;
  int cols;

  final Cursor cursor = Cursor();

  int currentForeground = 37;
  int currentBackground = 40;

  bool bold = false;
  bool underline = false;
  bool inverse = false;

  late List<List<TerminalCell>> lines;

  void _allocate() {
    lines = List.generate(
      rows,
      (_) => List.generate(
        cols,
        (_) => TerminalCell(),
      ),
    );
  }
