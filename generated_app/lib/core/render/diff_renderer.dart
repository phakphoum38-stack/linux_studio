import '../engine/terminal_cell.dart';

/// Diff between two screen buffers.
///
/// ใช้ตรวจว่า cell ไหนมีการเปลี่ยนแปลง
/// เพื่อลดการ repaint ทั้งหน้าจอ
class DiffRenderer {
  List<List<TerminalCell>>? _previous;

  /// Compare two cells.
  bool isDifferent(
    TerminalCell a,
    TerminalCell b,
  ) {
    return a.char != b.char ||
        a.foreground != b.foreground ||
        a.background != b.background ||
        a.bold != b.bold ||
        a.italic != b.italic ||
        a.underline != b.underline ||
        a.inverse != b.inverse;
  }

  /// Return changed cell positions.
  List<CellDiff> diff(
    List<List<TerminalCell>> current,
  ) {
    final changes = <CellDiff>[];

    if (_previous == null) {
      _previous = _clone(current);

      for (int r = 0; r < current.length; r++) {
        for (int c = 0; c < current[r].length; c++) {
          changes.add(
            CellDiff(
              row: r,
              col: c,
              cell: current[r][c].copy(),
            ),
          );
        }
      }

      return changes;
    }

    for (int r = 0; r < current.length; r++) {
      for (int c = 0; c < current[r].length; c++) {
        if (isDifferent(
          current[r][c],
          _previous![r][c],
        )) {
          changes.add(
            CellDiff(
              row: r,
              col: c,
              cell: current[r][c].copy(),
            ),
          );
        }
      }
    }

    _previous = _clone(current);

    return changes;
  }

  List<List<TerminalCell>> _clone(
    List<List<TerminalCell>> src,
  ) {
    return src
        .map(
          (row) => row
              .map(
                (cell) => cell.copy(),
              )
              .toList(),
        )
        .toList();
  }

  void reset() {
    _previous = null;
  }
}

/// One changed cell.
class CellDiff {
  final int row;
  final int col;
  final TerminalCell cell;

  const CellDiff({
    required this.row,
    required this.col,
    required this.cell,
  });
}
