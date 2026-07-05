 escape
      if (match.start > lastIndex) {
        onText?.call(data.substring(lastIndex, match.start));
      }

      final params = match.group(1) ?? '';
      final code = match.group(2) ?? '';

      final args = params.isEmpty
          ? <int>[]
          : params.split(';').map((e) => int.tryParse(e) ?? 0).toList();

      final command = _mapCommand(code);

      onCommand?.call(command, args);

      lastIndex = match.end;
    }

    // text `8    if (lastIndex < data.length) {
      onText?.call(data.substring(lastIndex));
    }
  }

  String _mapCommand(String code) {
    switch (code) {
      case 'A':
        return 'CUU'; // up
      case 'B':
        return 'CUD'; // down
      case 'C':
        return 'CUF'; // forward
      case 'D':
        return 'CUB'; // back
      case 'H':
      case 'f':
        return 'CUP'; // position
      case 'J':
        return 'ED'; // clear screen
      default:
        return 'UNKNOWN';
    }
  }
}class AnsiStreamParser {
  final StringBuffer _buffer = StringBuffer();

  Function(String text)? onText;
  Function(String command, List<int> args)? onCommand;

  void feed(String chunk) {
    _buffer.write(chunk);
    final data = _buffer.toString();
    _buffer.clear();

    _parse(data);
  }

  void _parse(String data) {
    final regex = RegExp(r'\x1B\[([0-9;]*)([A-Za-z])');

    int lastIndex = 0;

    for (final match in regex.allMatches(data)) {
``8-`8      // TEXT `8
