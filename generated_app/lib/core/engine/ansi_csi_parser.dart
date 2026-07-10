class AnsiEvent {}

class TextEvent extends AnsiEvent {
  TextEvent(
    this.text,
  );

  final String text;
}

class CsiEvent extends AnsiEvent {
  CsiEvent({
    required this.command,
    required this.args,
  });

  final String command;
  final List<int> args;
}

class AnsiCsiParser {
  List<AnsiEvent> parse(
    String input,
  ) {
    final events = <AnsiEvent>[];

    final text = StringBuffer();

    int i = 0;

    while (i < input.length) {
      final ch = input[i];

      if (ch == '\x1B') {
        if (text.isNotEmpty) {
          events.add(
            TextEvent(
              text.toString(),
            ),
          );

          text.clear();
        }

        if (i + 1 >= input.length) {
          break;
        }

        // CSI
        if (input[i + 1] == '[') {
          i += 2;

          final sequence = StringBuffer();

          while (i < input.length) {
            final c = input[i];

            if (_isCommand(c)) {
              final args =
                  _parseArguments(
                sequence.toString(),
              );

              events.add(
                CsiEvent(
                  command: c,
                  args: args,
                ),
              );

              break;
            }

            sequence.write(c);

            i++;
          }
        }
      } else {
        text.write(ch);
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

  bool _isCommand(
    String c,
  ) {
    return RegExp(
      r'[A-Za-z@`~]',
    ).hasMatch(c);
  }

  List<int> _parseArguments(
    String input,
  ) {
    if (input.isEmpty) {
      return [];
    }

    return input
        .split(';')
        .map(
          (e) =>
              int.tryParse(e) ??
              0,
        )
        .toList();
  }
}
