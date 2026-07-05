class AnsiColor {
  final int? fg;
  final int? bg;

  AnsiColor({this.fg, this.bg});
}

class AnsiColorParser {
  int fg = 7;
  int bg = 0;

  AnsiColor parseCode(List<int> params) {
    if (params.isEmpty) {
      fg = 7;
      bg = 0;
      return AnsiColor(fg: fg, bg: bg);
    }

    for (final p in params) {
      // reset
      if (p == 0) {
        fg = 7;
        bg = 0;
      }

      // basic colors
      if (p >= 30 && p <= 37) {
        fg = p - 30;
      }

      if (p >= 40 && p <= 47) {
        bg = p - 40;
      }

      // bright colors
      if (p >= 90 && p <= 97) {
        fg = p - 82;
      }
    }

    return AnsiColor(fg: fg, bg: bg);
  }
}
