class VT100Controller {
  int row = 0;
  int col = 0;

  void execute(String cmd, List<int> args, ScreenBuffer buffer) {
    switch (cmd) {
      case 'CUU':
        row = (row - (args.isEmpty ? 1 : args[0])).clamp(0, buffer.height - 1);
        break;

      case 'CUD':
        row = (row + (args.isEmpty ? 1 : args[0])).clamp(0, buffer.height - 1);
        break;

      case 'CUF':
        col = (col + (args.isEmpty ? 1 : args[0])).clamp(0, buffer.width - 1);
        break;

      case 'CUB':
        col = (col - (args.isEmpty ? 1 : args[0])).clamp(0, buffer.width - 1);
        break;

      case 'CUP':
        row = args.isNotEmpty ? args[0] : 0;
        col = args.length > 1 ? args[1] : 0;
        break;

      case 'ED': // clear screen
        buffer.clear();
        break;

      case 'EL': // clear line
        buffer.clearLine(row);
        break;
    }
  }
}
