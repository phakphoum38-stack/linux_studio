 class AnsiStreamParser {
  final StringBuffer _buffer = StringBuffer();

  void Function(String text)? onText;
  void Function(String command, List<int> args)? onCommand;

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

    if (lastIndex < data.length) {
      onText?.call(data.substring(lastIndex));
    }
  }

  String _mapCommand(String code) {
    switch (code) {
      case 'A':
        return 'CUU';
      case 'B':
        return 'CUD';
      case 'C':
        return 'CUF';
      case 'D':
        return 'CUB';
      case 'H':
      case 'f':
        return 'CUP';
      case 'J':
        return 'ED';
      default:
        return 'UNKNOWN';
    }
  }
}
