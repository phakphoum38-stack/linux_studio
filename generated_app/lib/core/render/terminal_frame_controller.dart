import '../engine/screen_buffer.dart';
import 'dirty_tracker.dart';

class TerminalFrameController {
  final DirtyTracker dirty = DirtyTracker();

  ScreenBuffer? buffer;
  ScreenBuffer? previous;

  void attach(ScreenBuffer buf) {
    buffer = buf;
    previous = ScreenBuffer(buf.width, buf.height);
  }

  bool shouldRepaint() {
    return dirty.dirtyCells.isNotEmpty;
  }

  void commitFrame() {
    if (buffer == null || previous == null) return;

    for (int r = 0; r < buffer!.height; r++) {
      for (int c = 0; c < buffer!.width; c++) {
        previous!.buffer[r][c] = buffer!.buffer[r][c];
      }
    }

    dirty.clear();
  }
}
