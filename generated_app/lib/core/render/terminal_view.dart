import '../engine/screen_buffer.dart';
import 'terminal_controller_v5.dart';

/// Lightweight TerminalView helper used for basic integration testing.
/// Not a Flutter widget — a small bridge between controller and buffer for now.
class TerminalView {
  final TerminalControllerV5 controller;
  final ScreenBuffer buffer;

  TerminalView(this.controller, this.buffer);

  /// Render buffer to a single string (for simple smoke tests).
  String renderToString() {
    final sb = StringBuffer();
    for (var r = 0; r < buffer.height; r++) {
      for (var c = 0; c < buffer.width; c++) {
        sb.write(buffer.charAt(r, c));
      }
      if (r != buffer.height - 1) sb.writeln();
    }
    return sb.toString();
  }
}
