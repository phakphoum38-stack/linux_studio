import '../engine/screen_buffer.dart';
import 'dirty_tracker.dart';

class TerminalFrameController {
  final DirtyTracker dirty;

  ScreenBuffer? buffer;
  ScreenBuffer? previous;

  TerminalFrameController({
    DirtyTracker? dirtyTracker,
  }) : dirty = dirtyTracker ?? DirtyTracker();

  /// Attach screen buffer
  void attach(
    ScreenBuffer buf,
  ) {
    buffer = buf;

    previous = ScreenBuffer(
      rows: buf.rows,
      cols: buf.cols,
    );
  }

  /// Check if repaint required
  bool shouldRepaint() {
    return dirty.dirtyCells.isNotEmpty;
  }

  /// Copy current frame to previous frame
  void commitFrame() {
    if (buffer == null || previous == null) {
      return;
    }

    for (int row = 0; row < buffer!.rows; row++) {
      for (int col = 0; col < buffer!.cols; col++) {
        previous!.buffer[row][col] =
            buffer!.buffer[row][col].copy();
      }
    }

    dirty.clear();
  }

  /// Mark full redraw
  void invalidateAll() {
    dirty.markAll(
      rows: buffer?.rows ?? 24,
      cols: buffer?.cols ?? 80,
    );
  }

  /// Mark one row redraw
  void invalidateRow(
    int row,
  ) {
    dirty.markRow(
      row,
      cols: buffer?.cols ?? 80,
    );
  }
}
