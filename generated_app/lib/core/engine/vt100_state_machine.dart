import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';

class VT100StateMachine {
  VT100StateMachine([
    ScreenBuffer? buffer,
  ]) : buffer = buffer ?? ScreenBuffer();

  final ScreenBuffer buffer;

  bool cursorVisible = true;

  int get cursorRow => buffer.cursor.row;

  int get cursorCol => buffer.cursor.col;

  set cursorRow(int value) {
    buffer.cursor.row =
        value.clamp(
          0,
          buffer.rows - 1,
        );
  }

  set cursorCol(int value) {
    buffer.cursor.col =
        value.clamp(
          0,
          buffer.cols - 1,
        );
  }

  void handle(
    AnsiEvent event,
  ) {
    if (event is TextEvent) {
      buffer.writeText(
        event.text,
      );
      return;
    }

    if (event is CsiEvent) {
      execute(
        event.command,
        event.args,
      );
    }
  }

  void execute(
    String command,
    List<int> args,
  ) {
    switch (command) {
      case 'A':
        _cursorUp(args);
        break;

      case 'B':
        _cursorDown(args);
        break;

      case 'C':
        _cursorForward(args);
        break;

      case 'D':
        _cursorBack(args);
        break;

      case 'H':
      case 'f':
        _cursorPosition(args);
        break;

      case 'J':
        _eraseDisplay(args);
        break;

      case 'K':
        _eraseLine(args);
        break;

      case 'm':
        _graphicsMode(args);
        break;

      case 'h':
        _modeSet(args);
        break;

      case 'l':
        _modeReset(args);
        break;
    }
  }

    int _value(
    List<int> args,
  ) {
    if (args.isEmpty) {
      return 1;
    }

    if (args.first == 0) {
      return 1;
    }

    return args.first;
  }

  void _cursorUp(
    List<int> args,
  ) {
    cursorRow -= _value(args);
  }

  void _cursorDown(
    List<int> args,
  ) {
    cursorRow += _value(args);
  }

  void _cursorForward(
    List<int> args,
  ) {
    cursorCol += _value(args);
  }

  void _cursorBack(
    List<int> args,
  ) {
    cursorCol -= _value(args);
  }

  void _cursorPosition(
    List<int> args,
  ) {
    cursorRow =
        (args.isNotEmpty
                ? args[0]
                : 1) -
            1;

    cursorCol =
        (args.length > 1
                ? args[1]
                : 1) -
            1;
  }

    // ==========================
  // Erase Display
  // ==========================

  void _eraseDisplay(
    List<int> args,
  ) {
    final mode =
        args.isEmpty ? 0 : args.first;

    switch (mode) {
      case 0:
        buffer.eraseToEndOfScreen();
        break;

      case 1:
        buffer.eraseToBeginningOfScreen();
        break;

      case 2:
      case 3:
        buffer.clear();
        break;
    }
  }

  // ==========================
  // Erase Line
  // ==========================

  void _eraseLine(
    List<int> args,
  ) {
    final mode =
        args.isEmpty ? 0 : args.first;

    switch (mode) {
      case 0:
        buffer.eraseToEndOfLine();
        break;

      case 1:
        buffer.eraseToBeginningOfLine();
        break;

      case 2:
        buffer.clearLine(
          buffer.cursor.row,
        );
        break;
    }
  }

  // ==========================
  // SGR (Graphics Mode)
  // ==========================

  void _graphicsMode(
    List<int> args,
  ) {
    if (args.isEmpty) {
      buffer.resetStyle();
      return;
    }

    for (final code in args) {
      switch (code) {
        case 0:
          buffer.resetStyle();
          break;

        case 1:
          buffer.bold = true;
          break;

        case 4:
          buffer.underline = true;
          break;

        case 7:
          buffer.inverse = true;
          break;

        case 22:
          buffer.bold = false;
          break;

        case 24:
          buffer.underline = false;
          break;

        case 27:
          buffer.inverse = false;
          break;

        default:
          if (code >= 30 && code <= 37) {
            buffer.currentForeground = code;
          }

          if (code >= 40 && code <= 47) {
            buffer.currentBackground = code;
          }

          if (code >= 90 && code <= 97) {
            buffer.currentForeground = code;
          }

          if (code >= 100 && code <= 107) {
            buffer.currentBackground = code;
          }
      }
    }
  }

  // ==========================
  // DEC Mode Set / Reset
  // ==========================

  void _modeSet(
    List<int> args,
  ) {
    if (args.contains(25)) {
      cursorVisible = true;
    }
  }

  void _modeReset(
    List<int> args,
  ) {
    if (args.contains(25)) {
      cursorVisible = false;
    }
  }

    // ==========================
  // Save / Restore Cursor
  // ==========================

  int _savedRow = 0;
  int _savedCol = 0;

  void saveCursor() {
    _savedRow = cursorRow;
    _savedCol = cursorCol;
  }

  void restoreCursor() {
    cursorRow = _savedRow;
    cursorCol = _savedCol;
  }

  // ==========================
  // Scroll
  // ==========================

  void scrollUp(
    int count,
  ) {
    for (int i = 0; i < count; i++) {
      buffer.scrollUp();
    }
  }

  void scrollDown(
    int count,
  ) {
    for (int i = 0; i < count; i++) {
      buffer.lines.insert(
        0,
        List.generate(
          buffer.cols,
          (_) => TerminalCell(),
        ),
      );

      if (buffer.lines.length > buffer.rows) {
        buffer.lines.removeLast();
      }
    }
  }

  // ==========================
  // Insert/Delete Line
  // ==========================

  void insertLine() {
    buffer.lines.insert(
      cursorRow,
      List.generate(
        buffer.cols,
        (_) => TerminalCell(),
      ),
    );

    if (buffer.lines.length > buffer.rows) {
      buffer.lines.removeLast();
    }
  }

  void deleteLine() {
    if (cursorRow >= buffer.rows) {
      return;
    }

    buffer.lines.removeAt(cursorRow);

    buffer.lines.add(
      List.generate(
        buffer.cols,
        (_) => TerminalCell(),
      ),
    );
  }

  // ==========================
  // Insert/Delete Character
  // ==========================

  void insertCharacter() {
    buffer.insertChar();
  }

  void deleteCharacter() {
    buffer.deleteChar();
  }

  // ==========================
  // Device Status Report
  // ==========================

  String deviceStatus() {
    return '\u001B[0n';
  }

  // ==========================
  // Reset Terminal
  // ==========================

  void reset() {
    buffer.clear();
    cursorVisible = true;

    _savedRow = 0;
    _savedCol = 0;
  }
}
}
