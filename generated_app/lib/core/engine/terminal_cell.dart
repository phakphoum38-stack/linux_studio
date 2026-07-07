class TerminalCell {
  String char;

  /// ANSI foreground color
  int foreground;

  /// ANSI background color
  int background;

  bool bold;
  bool italic;
  bool underline;
  bool inverse;

  TerminalCell({
    this.char = ' ',
    this.foreground = 37,
    this.background = 40,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.inverse = false,
  });

  // Backward compatibility
  int get fg => foreground;
  set fg(int value) => foreground = value;

  int get bg => background;
  set bg(int value) => background = value;

  TerminalCell copy() {
    return TerminalCell(
      char: char,
      foreground: foreground,
      background: background,
      bold: bold,
      italic: italic,
      underline: underline,
      inverse: inverse,
    );
  }

  void reset() {
    char = ' ';
    foreground = 37;
    background = 40;
    bold = false;
    italic = false;
    underline = false;
    inverse = false;
  }

  @override
  String toString() {
    return char;
  }
}
