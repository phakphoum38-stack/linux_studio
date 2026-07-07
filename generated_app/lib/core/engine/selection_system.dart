import 'screen_buffer.dart';

class SelectionSystem {
  int? startRow;
  int? startCol;

  int? endRow;
  int? endCol;


  bool get active =>
      startRow != null &&
      startCol != null &&
      endRow != null &&
      endCol != null;



  void start(
    int row,
    int col,
  ) {
    startRow = row;
    startCol = col;

    endRow = row;
    endCol = col;
  }



  void update(
    int row,
    int col,
  ) {
    if (!active) {
      return;
    }

    endRow = row;
    endCol = col;
  }



  void clear() {

    startRow = null;
    startCol = null;

    endRow = null;
    endCol = null;
  }




  String extract(
    ScreenBuffer buffer,
  ) {

    if (!active) {
      return '';
    }


    int sRow = startRow!;
    int eRow = endRow!;

    int sCol = startCol!;
    int eCol = endCol!;



    // normalize direction

    if (sRow > eRow) {
      final t = sRow;
      sRow = eRow;
      eRow = t;

      final c = sCol;
      sCol = eCol;
      eCol = c;
    }



    final result = StringBuffer();



    for (
      int row = sRow;
      row <= eRow;
      row++
    ) {

      if (row < 0 ||
          row >= buffer.rows) {
        continue;
      }


      int left = 0;
      int right = buffer.cols - 1;



      if (sRow == eRow) {

        left = sCol < eCol
            ? sCol
            : eCol;

        right = sCol > eCol
            ? sCol
            : eCol;

      }
      else if (row == sRow) {

        left = sCol;

      }
      else if (row == eRow) {

        right = eCol;
      }



      left = left.clamp(
        0,
        buffer.cols - 1,
      );

      right = right.clamp(
        0,
        buffer.cols - 1,
      );



      for (
        int col = left;
        col <= right;
        col++
      ) {

        result.write(
          buffer
              .cellAt(row, col)
              .char,
        );
      }



      if (row != eRow) {
        result.writeln();
      }
    }


    return result.toString();
  }
}
