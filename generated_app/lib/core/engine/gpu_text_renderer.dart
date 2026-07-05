import 'screen_buffer.dart';

class GpuTextRenderer {
  List<List<String>>? prev;

  List<Map<String, dynamic>> diff(ScreenBuffer buffer) {
    final changes = <Map<String, dynamic>>[];

    if (prev == null) {
      prev = _snapshot(buffer);
      return [{"full": true}];
    }

    for (int r = 0; r < buffer.rows; r++) {
      for (int c = 0; c < buffer.cols; c++) {
        final cur = buffer.buffer[r][c].char;
        final old = prev![r][c];

        if (cur != old) {
          changes.add({
            "r": r,
            "c": c,
            "char": cur,
          });
        }
      }
    }

    prev = _snapshot(buffer);

    return changes;
  }

  List<List<String>> _snapshot(ScreenBuffer buffer) {
    return buffer.buffer
        .map((row) => row.map((c) => c.char).toList())
        .toList();
  }
}
