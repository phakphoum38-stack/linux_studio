class AnsiStreamParser {
  final StringBuffer _buffer = StringBuffer();

  Function(String text)? onText;
  Function(String command, List<int> args)? onCommand;

  /// Feed incoming stream data
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
      // TEXT before escape sequence
      if (match.start > lastIndex) {
        onText?.call(data.substring(lastIndex, match.start));
      }

      final params = match.group(1) ?? '';
      final code = match.group(2) ?? '';

      final args = params.isEmpty
          ? <int>[]
          : params
              .split(';')
              .map((e) => int.tryParse(e) ?? 0)
              .toList();

      final command = _mapCommand(code);
      onCommand?.call(command, args);

      lastIndex = match.end;
    }

    // remaining text after last escape
    if (lastIndex < data.length) {
      onText?.call(data.substring(lastIndex));
    }
  }

  /// Map ANSI codes → terminal actions
  String _mapCommand(String code) {
    switch (code) {
      case 'A':
        return 'CUU'; // cursor up
      case 'B':
        return 'CUD'; // cursor down
      case 'C':
        return 'CUF'; // cursor forward
      case 'D':
        return 'CUB'; // cursor back
      case 'H':
      case 'f':
        return 'CUP'; // cursor position
      case 'J':
        return 'ED'; // erase display
      case 'K':
        return 'EL'; // erase line
      default:
        return 'UNKNOWN';
    }
  }
}
