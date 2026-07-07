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

  void start(int row, int col) {
    startRow = row;
    startCol = col;

    endRow = row;
    endCol = col;
  }

  void update(int row, int col) {
    endRow = row;
    endCol = col;
  }

  void clear() {
    startRow = null;
    startCol = null;
    endRow = null;
    endCol = null;
  }

  String extract(ScreenBuffer buffer) {
    if (!active) {
      return '';
    }

    final topRow = startRow! <= endRow! ? startRow! : endRow!;
    final bottomRow = startRow! <= endRow! ? endRow! : startRow!;

    final sb = StringBuffer();

    for (int row = topRow; row <= bottomRow; row++) {
      int left = 0;
      int right = buffer.cols - 1;

      if (row == startRow && row == endRow) {
        left = startCol! < endCol! ? startCol! : endCol!;
        right = startCol! > endCol! ? startCol! : endCol!;
      } else if (row == startRow) {
        left = startCol!;
      } else if (row == endRow) {
        right = endCol!;
      }

      left = left.clamp(0, buffer.cols - 1);
      right = right.clamp(0, buffer.cols - 1);

      for (int col = left; col <= right; col++) {
        sb.write(buffer.buffer[row][col].char);
      }

      if (row != bottomRow) {
        sb.writeln();
      }
    }

    return sb.toString();
  }
}
