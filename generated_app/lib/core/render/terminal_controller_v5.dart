import 'package:characters/characters.dart';

import '../engine/screen_buffer.dart';
import 'render_pipeline.dart';

class TerminalControllerV5 {
  final ScreenBuffer screen;
  final RenderPipeline pipeline;

  int cursorRow = 0;
  int cursorCol = 0;

  TerminalControllerV5({
    required this.screen,
    required this.pipeline,
  });

  void write(String data) {
    for (final ch in data.characters) {
      _putChar(ch);
    }

    pipeline.invalidateAll();
  }

  void _putChar(String ch) {
    switch (ch) {
      case '\n':
        cursorRow++;
        cursorCol = 0;
        return;

      case '\r':
        cursorCol = 0;
        return;
    }

    if (!screen.inBounds(cursorRow, cursorCol)) {
      return;
    }

    screen.buffer[cursorRow][cursorCol].char = ch;

    pipeline.invalidateRow(cursorRow, screen.cols);

    cursorCol++;

    if (cursorCol >= screen.cols) {
      cursorCol = 0;
      cursorRow++;

      if (cursorRow >= screen.rows) {
        cursorRow = screen.rows - 1;
      }
    }
  }

  void moveCursor(
    int row,
    int col,
  ) {
    cursorRow = row.clamp(0, screen.rows - 1);
    cursorCol = col.clamp(0, screen.cols - 1);
  }

  void clear() {
    screen.clear();

    cursorRow = 0;
    cursorCol = 0;

    pipeline.invalidateAll();
  }

  void reset() {
    clear();
  }
}
