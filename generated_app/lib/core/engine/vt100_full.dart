class VT100Full {
  int row = 0;
  int col = 0;

  void execute(String cmd, List<int> args, ScreenBuffer buffer) {
    switch (cmd) {
      case 'CUU':
        row = (row - (args.isEmpty ? 1 : args[0]))
            .clamp(0, buffer.height - 1);
        break;

      case 'CUD':
        row = (row + (args.isEmpty ? 1 : args[0]))
            .clamp(0, buffer.height - 1);
        break;

      case 'CUF':
        col = (col + (args.isEmpty ? 1 : args[0]))
            .clamp(0, buffer.width - 1);
        break;

      case 'CUB':
        col = (col - (args.isEmpty ? 1 : args[0]))
            .clamp(0, buffer.width - 1);
        break;

      case 'CUP':
        row = args.isNotEmpty ? args[0] : 0;
        col = args.length > 1 ? args[1] : 0;
        break;

      case 'ED':
        buffer.clear();
        break;

      case 'EL':
        buffer.clearLine(row);
        break;

      case 'ICH': // insert char
        buffer.insertChar(row, col);
        break;

      case 'DCH': // delete char
        buffer.deleteChar(row, col);
        break;

      case 'SU': // scroll up
        buffer.scrollUp(args.isEmpty ? 1 : args[0]);
        break;

      case 'SD': // scroll down
        buffer.scrollDown(args.isEmpty ? 1 : args[0]);
        break;
    }
  }
}
