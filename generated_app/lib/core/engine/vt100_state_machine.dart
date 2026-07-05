class VT100StateMachine {
  int cursorRow = 0;
  int cursorCol = 0;

  int fgColor = 37;
  int bgColor = 40;

  void applyCommand(String cmd, List<int> args) {
    switch (cmd) {
      case 'SGR':
        _handleSGR(args);
        break;
    }
  }

  void _handleSGR(List<int> args) {
    if (args.isEmpty) {
      fgColor = 37;
      bgColor = 40;
      return;
    }

    for (final code in args) {
      if (code >= 30 && code <= 37) {
        fgColor = code;
      }
      if (code >= 40 && code <= 47) {
        bgColor = code;
      }
    }
  }
}
