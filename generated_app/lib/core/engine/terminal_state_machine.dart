import 'screen_buffer.dart';

class TerminalStateMachine {
  final ScreenBuffer buffer;

  TerminalStateMachine(this.buffer);

  void feedChar(String char) {
    switch (char) {
      case '\n':
        buffer.cursorDown();
        buffer.carriageReturn();
        break;

      case '\r':
        buffer.carriageReturn();
        break;

      case '\b':
        buffer.cursorBack();
        break;

      case '\t':
        buffer.tab();
        break;

      default:
        buffer.putChar(char);
    }
  }

  void feed(String data) {
    for (final rune in data.runes) {
      feedChar(String.fromCharCode(rune));
    }
  }
}
