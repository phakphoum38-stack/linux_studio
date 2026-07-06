import '../engine/screen_buffer.dart';
import 'render_pipeline.dart';

/// Release 1.0 Safe Controller Stub
///
/// เป้าหมาย:
/// - ให้ compile ผ่าน
/// - แทน DirtyTracker / Cursor system ที่ยังไม่ครบ
/// - เตรียม upgrade เป็น full VT engine ใน Phase 2
class TerminalControllerV5 {
  final ScreenBuffer screen;
  final RenderPipeline pipeline;

  int cursorRow = 0;
  int cursorCol = 0;

  TerminalControllerV5({
    required this.screen,
    required this.pipeline,
  });

  /// Write character stream
  void write(String data) {
    for (final char in data.split('')) {
      _putChar(char);
    }

    pipeline.invalidateAll();
  }

  void _putChar(String char) {
    if (char == '\n') {
      cursorRow++;
      cursorCol = 0;
      return;
    }

    if (char == '\r') {
      cursorCol = 0;
      return;
    }

    if (cursorRow >= screen.height || cursorCol >= screen.width) {
      return;
    }

    screen.buffer[cursorRow][cursorCol].char = char;
    pipeline.invalidateRow(cursorRow);

    cursorCol++;
    if (cursorCol >= screen.width) {
      cursorCol = 0;
      cursorRow++;
    }
  }

  /// Move cursor
  void moveCursor(int row, int col) {
    cursorRow = row.clamp(0, screen.height - 1);
    cursorCol = col.clamp(0, screen.width - 1);
  }

  /// Clear screen
  void clear() {
    screen.clear();
    pipeline.invalidateAll();
    cursorRow = 0;
    cursorCol = 0;
  }

  /// Reset state
  void reset() {
    clear();
  }
}
