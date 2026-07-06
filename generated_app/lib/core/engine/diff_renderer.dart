import '../engine/terminal_cell.dart';

class DiffRenderer {
  bool isDifferent(TerminalCell a, TerminalCell b) {
    return a.char != b.char ||
        a.fg != b.fg ||
        a.bg != b.bg;
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
