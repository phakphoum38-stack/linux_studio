import 'screen_buffer.dart';
import 'terminal_cell.dart';

class VT100Full {
  int row = 0;
  int col = 0;


  void execute(
    String cmd,
    List<int> args,
    ScreenBuffer buffer,
  ) {

    final count =
        args.isEmpty ? 1 : args[0];


    switch (cmd) {

      case 'CUU':
        row = (row - count)
            .clamp(0, buffer.rows - 1);
        break;


      case 'CUD':
        row = (row + count)
            .clamp(0, buffer.rows - 1);
        break;


      case 'CUF':
        col = (col + count)
            .clamp(0, buffer.cols - 1);
        break;


      case 'CUB':
        col = (col - count)
            .clamp(0, buffer.cols - 1);
        break;


      case 'CUP':

        row = (args.isNotEmpty
                ? args[0] - 1
                : 0)
            .clamp(
              0,
              buffer.rows - 1,
            );


        col = (args.length > 1
                ? args[1] - 1
                : 0)
            .clamp(
              0,
              buffer.cols - 1,
            );

        break;


      case 'ED':
        buffer.clear();
        row = 0;
        col = 0;
        break;


      case 'EL':
        _clearLine(
          buffer,
          row,
        );
        break;


      case 'ICH':
        _insertChar(
          buffer,
          row,
          col,
        );
        break;


      case 'DCH':
        _deleteChar(
          buffer,
          row,
          col,
        );
        break;


      case 'SU':
        for (int i = 0; i < count; i++) {
          buffer.scrollUp();
        }
        break;


      case 'SD':
        _scrollDown(
          buffer,
          count,
        );
        break;
    }
  }



  void _clearLine(
    ScreenBuffer buffer,
    int r,
  ) {

    if (!buffer.inBounds(r, 0)) {
      return;
    }


    for (int c = 0; c < buffer.cols; c++) {

      buffer.buffer[r][c] =
          TerminalCell();
    }
  }



  void _insertChar(
    ScreenBuffer buffer,
    int r,
    int c,
  ) {

    if (!buffer.inBounds(r, c)) {
      return;
    }


    for (
      int x = buffer.cols - 1;
      x > c;
      x--
    ) {

      buffer.buffer[r][x] =
          buffer.buffer[r][x - 1].copy();
    }


    buffer.buffer[r][c] =
        TerminalCell();
  }



  void _deleteChar(
    ScreenBuffer buffer,
    int r,
    int c,
  ) {

    if (!buffer.inBounds(r, c)) {
      return;
    }


    for (
      int x = c;
      x < buffer.cols - 1;
      x++
    ) {

      buffer.buffer[r][x] =
          buffer.buffer[r][x + 1].copy();
    }


    buffer.buffer[r][buffer.cols - 1] =
        TerminalCell();
  }



  void _scrollDown(
    ScreenBuffer buffer,
    int count,
  ) {

    for (int i = 0; i < count; i++) {

      buffer.buffer.insert(
        0,
        List.generate(
          buffer.cols,
          (_) => TerminalCell(),
        ),
      );


      if (buffer.buffer.length > buffer.rows) {
        buffer.buffer.removeLast();
      }
    }
  }
}
