import 'screen_buffer.dart';

class TerminalRenderer {
  final ScreenBuffer buffer;

  TerminalRenderer(this.buffer);

  List<String> render() {
    return buffer.grid.map((row) {
      return row.map((cell) => cell.char).join();
    }).toList();
  }
}
