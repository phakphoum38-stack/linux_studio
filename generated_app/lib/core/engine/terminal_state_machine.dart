import 'screen_buffer.dart';
import 'ansi_csi_parser.dart';

class TerminalStateMachine {
  final ScreenBuffer buffer;

  TerminalStateMachine(this.buffer);

  void execute(dynamic event) {
    if (event is String) {
      buffer.write(event);
      return;
    }

    if (event is CsiEvent) {
      switch (event.type) {
        case 'A': // up
          buffer.cursor.row =
              (buffer.cursor.row - 1).clamp(0, buffer.rows - 1);
          break;

        case 'B': // down
          buffer.cursor.row =
              (buffer.cursor.row + 1).clamp(0, buffer.rows - 1);
          break;

        case 'C': // right
          buffer.cursor.col =
              (buffer.cursor.col + 1).clamp(0, buffer.cols - 1);
          break;

        case 'D': // left
          buffer.cursor.col =
              (buffer.cursor.col - 1).clamp(0, buffer.cols - 1);
          break;

        case 'H': // home
          buffer.cursor.set(0, 0);
          break;

        case 'J': // clear screen
          buffer.clear();
          break;

        case 'K': // clear line
          final row = buffer.cursor.row;
          for (int c = 0; c < buffer.cols; c++) {
            buffer.buffer[row][c].char = ' ';
          }
          break;
      }
    }
  }
}
