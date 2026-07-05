class AnsiColor {
  final String color;

  const AnsiColor(this.color);
}

class AnsiParser {
  static final Map<String, String> colorMap = {
    '31': 'red',
    '32': 'green',
    '33': 'yellow',
    '34': 'blue',
    '35': 'magenta',
    '36': 'cyan',
    '37': 'white',
  };

  static String clean(String input) {
    return input.replaceAll(RegExp(r'\x1b\[[0-9;]*m'), '');
  }

  static List<_Token> parse(String input) {
    final regex = RegExp(r'(\x1b\[[0-9;]*m)|([^\x1b]+)');
    final matches = regex.allMatches(input);

    String currentColor = 'default';
    final tokens = <_Token>[];

    for (final m in matches) {
      final part = m.group(0)!;

      if (part.startsWith('\x1b')) {
        final code = RegExp(r'\[(\d+)m')
            .firstMatch(part)
            ?.group(1);

        if (code == '0') {
          currentColor = 'default';
        } else if (colorMap.containsKey(code)) {
          currentColor = colorMap[code]!;
        }
      } else {
        for (final char in part.split('')) {
          tokens.add(_Token(char, currentColor));
        }
      }
    }

    return tokens;
  }
}

class _Token {
  final String char;
  final String color;

  _Token(this.char, this.color);
}
