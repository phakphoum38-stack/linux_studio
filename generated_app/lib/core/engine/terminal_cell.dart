class TerminalCell {
  String char;

  int fg;
  int bg;

  bool bold;
  bool italic;
  bool underline;
  bool inverse;

  TerminalCell({
    this.char = ' ',
    this.fg = 37,
    this.bg = 40,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.inverse = false,
  });

  TerminalCell copy() {
    return TerminalCell(
      char: char,
      fg: fg,
      bg: bg,
      bold: bold,
      italic: italic,
      underline: underline,
      inverse: inverse,
    );
  }
}
