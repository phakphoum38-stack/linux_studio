import '../engine/screen_buffer.dart';

class DiffRenderer {
  void render(
    ScreenBuffer buffer,
    ScreenBuffer previous,
    Function(int r, int c, ScreenCell cell) draw,
  ) {
    for (int r = 0; r < buffer.height; r++) {
      for (int c = 0; c < buffer.width; c++) {
        final current = buffer.buffer[r][c];
        final old = previous.buffer[r][c];

        if (current.char != old.char ||
            current.fg != old.fg ||
            current.bg != old.bg) {
          draw(r, c, current);
        }
      }
    }
  }
}
