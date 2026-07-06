import '../engine/screen_buffer.dart';

class TerminalControllerV5 {
  ScreenBuffer buffer;

  TerminalControllerV5(this.buffer);

  void putString(int row, int col, String text) {
    for (int i = 0; i < text.length; i++) {
      final c = text[i];
      if (col + i >= buffer.width) break;
      buffer.setChar(row, col + i, c);
    }
  }

  void clearScreen() => buffer.clear();
}
