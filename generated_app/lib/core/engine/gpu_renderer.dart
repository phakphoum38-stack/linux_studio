import 'screen_buffer.dart';

class GpuRenderer {
  List<List<String>>? _lastFrame;

  List<Map<String, dynamic>> diff(ScreenBuffer buffer) {
    final changes = <Map<String, dynamic>>[];

    if (_lastFrame == null) {
      _lastFrame = _snapshot(buffer);
      return [
        {
          "full": true,
        }
      ];
    }

    for (int r = 0; r < buffer.rows; r++) {
      for (int c = 0; c < buffer.cols; c++) {
        final current = buffer.buffer[r][c].char;
        final prev = _lastFrame![r][c];

        if (current != prev) {
          changes.add({
            "row": r,
            "col": c,
            "char": current,
          });
        }
      }
    }

    _lastFrame = _snapshot(buffer);

    return changes;
  }

  List<List<String>> _snapshot(ScreenBuffer buffer) {
    return buffer.buffer
        .map((row) => row.map((c) => c.char).toList())
        .toList();
  }
}
