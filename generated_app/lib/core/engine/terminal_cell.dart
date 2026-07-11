class TerminalCell {
  String char;

  int foreground;

  int background;

  bool bold;

  bool underline;

  bool italic;

  TerminalCell({
    this.char = ' ',
    this.foreground = 37,
    this.background = 40,
    this.bold = false,
    this.underline = false,
    this.italic = false,
  });

  int get fg => foreground;

  set fg(int value) {
    foreground = value;
  }

  int get bg => background;

  set bg(int value) {
    background = value;
  }

  void clear() {
    char = ' ';
    foreground = 37;
    background = 40;
    bold = false;
    underline = false;
    italic = false;
  }
}
