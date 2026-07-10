class AnsiEvent {}

class TextEvent extends AnsiEvent {
  TextEvent(this.text);

  final String text;
}

class CsiEvent extends AnsiEvent {
  CsiEvent(
    this.command,
    this.args,
  );

  final String command;
  final List<int> args;
}

class AnsiCsiParser {
  const AnsiCsiParser();

  List<AnsiEvent> parse(String input) {
    final events = <AnsiEvent>[];

    final text = StringBuffer();

    int i = 0;

    while (i < input.length) {
      final ch = input.codeUnitAt(i);

      // ESC
      if (ch == 0x1B) {
        // Flush text ก่อน
        if (text.isNotEmpty) {
          events.add(
            TextEvent(
              text.toString(),
            ),
          );

          text.clear();
        }

        // CSI
        if (i + 1 < input.length &&
            input.codeUnitAt(i + 1) == 0x5B) {
          i += 2;

          final buffer = StringBuffer();

          while (i < input.length) {
            final c = input[i];

            final code = c.codeUnitAt(0);

            if (code >= 0x40 && code <= 0x7E) {
              final args = _parseArgs(
                buffer.toString(),
              );

              events.add(
                CsiEvent(
                  c,
                  args,
                ),
              );

              break;
            }

            buffer.write(c);
            i++;
          }
        }
      } else {
        text.writeCharCode(ch);
      }

      i++;
    }

    if (text.isNotEmpty) {
      events.add(
        TextEvent(
          text.toString(),
        ),
      );
    }

    return events;
  }

  List<int> _parseArgs(
    String source,
  ) {
    if (source.isEmpty) {
      return const [];
    }

    final parts = source.split(';');

    return parts.map((e) {
      return int.tryParse(e) ?? 0;
    }).toList();
  }
}
