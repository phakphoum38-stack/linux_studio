import '../engine/terminal_cell.dart';


class DiffRenderer {

  List<List<TerminalCell>>? _previous;



  List<CellDiff> diff(
    List<List<TerminalCell>> current,
  ) {

    final changes = <CellDiff>[];


    if (_previous == null) {

      _previous =
          _clone(current);

      return changes;
    }



    for (int r = 0;
        r < current.length;
        r++) {


      for (int c = 0;
          c < current[r].length;
          c++) {


        if (isDifferent(
          current[r][c],
          _previous![r][c],
        )) {


          changes.add(
            CellDiff(
              row: r,
              col: c,
              cell:
                  current[r][c]
                  .copy(),
            ),
          );
        }
      }
    }



    _previous =
        _clone(current);


    return changes;
  }



  bool isDifferent(
    TerminalCell a,
    TerminalCell b,
  ) {

    return a.char != b.char ||
        a.fg != b.fg ||
        a.bg != b.bg;
  }



  List<List<TerminalCell>> _clone(
    List<List<TerminalCell>> source,
  ) {

    return source
        .map(
          (row) => row
              .map(
                (c) => c.copy(),
              )
              .toList(),
        )
        .toList();
  }



  void reset() {

    _previous = null;
  }
}



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
