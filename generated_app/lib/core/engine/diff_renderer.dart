import 'terminal_cell.dart';

class DiffRenderer {
  List<List<TerminalCell>>? _prev;

  List<Map<String, dynamic>> compute(
    List<List<TerminalCell>> current,
  ) {
    final changes = <Map<String, dynamic>>[];

    if (_prev == null) {
      _prev = _clone(current);
      return [
        {
          "full": true,
          "buffer": current,
        }
      ];
    }

    for (int r = 0; r < current.length; r++) {
      for (int c = 0; c < current[r].length; c++) {
        final cur = current[r][c];
        final prev = _prev![r][c];

        if (cur.char != prev.char ||
            cur.fg != prev.fg ||
            cur.bg != prev.bg) {
          changes.add({
            "row": r,
            "col": c,
            "cell": cur,
          });
        }
      }
    }

    _prev = _clone(current);

    return changes;
  }

  List<List<TerminalCell>> _clone(List<List<TerminalCell>> src) {
    return src
        .map((row) => row.map((c) => c.copy()).toList())
        .toList();
  }
}
