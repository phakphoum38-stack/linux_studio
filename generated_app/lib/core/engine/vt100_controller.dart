import 'screen_buffer.dart';

class VT100Controller {
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
    }
  }


  void _clearLine(
    ScreenBuffer buffer,
    int line,
  ) {

    if (line < 0 ||
        line >= buffer.rows) {
      return;
    }


    for (int c = 0; c < buffer.cols; c++) {

      buffer.buffer[line][c].char = ' ';
    }
  }
}
