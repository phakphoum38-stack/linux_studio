class TerminalCell {
  String char;

  int fg;
  int bg;

  bool bold;
  bool italic;
  bool underline;

  TerminalCell({
    this.char = ' ',
    this.fg = 7,
    this.bg = 0,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });

  void reset() {
    char = ' ';
    fg = 7;
    bg = 0;
    bold = false;
    italic = false;
    underline = false;
  }

  TerminalCell copy() {
    return TerminalCell(
      char: char,
      fg: fg,
      bg: bg,
      bold: bold,
      italic: italic,
      underline: underline,
    );
  }
}
