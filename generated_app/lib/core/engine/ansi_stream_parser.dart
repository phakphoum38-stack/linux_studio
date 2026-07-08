typedef TextCallback = void Function(String text);
typedef CommandCallback = void Function(String command, List<int> args);

class AnsiStreamParser {
  final StringBuffer _buffer = StringBuffer();

  TextCallback? onText;
  CommandCallback? onCommand;

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
      // TEXT ก่อน ANSI escape
      if (match.start > lastIndex) {
        onText?.call(data.substring(lastIndex, match.start));
      }

      final params = match.group(1) ?? '';
      final code = match.group(2) ?? '';

      final args = params.isEmpty
          ? <int>[]
          : params.split(';').map((e) {
              return int.tryParse(e) ?? 0;
            }).toList();

      final command = _mapCommand(code);

      onCommand?.call(command, args);

      lastIndex = match.end;
    }

    // TEXT ที่เหลือท้าย string
    if (lastIndex < data.length) {
      onText?.call(data.substring(lastIndex));
    }
  }

  String _mapCommand(String code) {
    switch (code) {
      case 'A':
        return 'A'; // cursor up
      case 'B':
        return 'B'; // cursor down
      case 'C':
        return 'C'; // cursor forward
      case 'D':
        return 'D'; // cursor back
      case 'H':
      case 'f':
        return 'H'; // cursor position
      case 'J':
        return 'J'; // erase screen
      case 'K':
        return 'K'; // erase line
      default:
        return 'UNKNOWN';
    }
  }
}
