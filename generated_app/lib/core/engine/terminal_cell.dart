class TerminalCell {
  TerminalCell({
    this.char = ' ',
    this.foreground = 37,
    this.background = 40,
    this.bold = false,
    this.underline = false,
    this.italic = false,
    this.inverse = false,
  });

  String char;
  int foreground;
  int background;
  bool bold;
  bool underline;
  bool italic;
  bool inverse;

  int get fg => foreground;
  set fg(int value) => foreground = value;

  int get bg => background;
  set bg(int value) => background = value;

  TerminalCell copy() => TerminalCell(
        char: char,
        foreground: foreground,
        background: background,
        bold: bold,
        underline: underline,
        italic: italic,
        inverse: inverse,
      );

  void clear() {
    char = ' ';
    foreground = 37;
    background = 40;
    bold = false;
    underline = false;
    italic = false;
    inverse = false;
  }
}
