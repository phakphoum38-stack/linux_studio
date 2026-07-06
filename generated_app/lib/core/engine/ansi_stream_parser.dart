 import 'dart:core';

typedef TextCallback = void Function(String text);
typedef CommandCallback = void Function(
  String command,
  List<int> args,
);

class AnsiStreamParser {
  final StringBuffer _buffer = StringBuffer();

  TextCallback? onText;
  CommandCallback? onCommand;

  void feed(String chunk) {
    if (chunk.isEmpty) return;

    _buffer.write(chunk);

    final data = _buffer.toString();

    _buffer.clear();

    _parse(data);
  }

  void _parse(String data) {
    final regex =
        RegExp(r'\x1B\[([0-9;?]*)([@-~])');

    int lastIndex = 0;

    for (final match in regex.allMatches(data)) {
      if (match.start > lastIndex) {
        onText?.call(
          data.substring(lastIndex, match.start),
        );
      }

      final params =
          match.group(1) ?? '';

      final code =
          match.group(2) ?? '';

      final args = params.isEmpty
          ? <int>[]
          : params
              .replaceAll('?', '')
              .split(';')
              .where((e) => e.isNotEmpty)
              .map(
                (e) => int.tryParse(e) ?? 0,
              )
              .toList();

      onCommand?.call(
        _mapCommand(code),
        args,
      );

      lastIndex = match.end;
    }

    if (lastIndex < data.length) {
      onText?.call(
        data.substring(lastIndex),
      );
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

      case 'E':
        return 'CNL';

      case 'F':
        return 'CPL';

      case 'G':
        return 'CHA';

      case 'H':
      case 'f':
        return 'CUP';

      case 'J':
        return 'ED';

      case 'K':
        return 'EL';

      case 'L':
        return 'IL';

      case 'M':
        return 'DL';

      case 'P':
        return 'DCH';

      case '@':
        return 'ICH';

      case 'X':
        return 'ECH';

      case 'S':
        return 'SU';

      case 'T':
        return 'SD';

      case 'm':
        return 'SGR';

      case 's':
        return 'SCP';

      case 'u':
        return 'RCP';

      case 'n':
        return 'DSR';

      case 'h':
        return 'SM';

      case 'l':
        return 'RM';

      default:
        return code;
    }
  }
}
