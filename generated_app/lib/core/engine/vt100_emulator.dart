class Vt100Emulator {
  int cursorRow = 0;
  int cursorCol = 0;

  void executeEsc(String code) {
    // minimal VT100 core subset
    switch (code) {
      case '[2J': // clear screen
        clear();
        break;

      case '[H': // home
        cursorRow = 0;
        cursorCol = 0;
        break;
    }
  }

  void clear() {
    cursorRow = 0;
    cursorCol = 0;
  }
}
