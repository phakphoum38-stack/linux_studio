class AnsiEvent {
  final String? text;

  final String? command;
  final List<int>? params;

  AnsiEvent.text(this.text)
      : command = null,
        params = null;

  AnsiEvent.command(this.command, this.params)
      : text = null;
}

class AnsiParser {
  final RegExp _regex = RegExp(r'\x1b\[([0-9;]*)?([A-Za-z])');

  List<AnsiEvent> parse(String input) {
    final List<AnsiEvent> out = [];

    input.splitMapJoin(
      _regex,
      onMatch: (m) {
        final full = m.group(0)!;
        final code = m.group(2);
        final paramsRaw = m.group(1) ?? '';

        final params = paramsRaw.isEmpty
            ? <int>[]
            : paramsRaw.split(';').map(int.parse).toList();

        out.add(AnsiEvent.command(code ?? '', params));

        return '';
      },
      onNonMatch: (text) {
        out.add(AnsiEvent.text(text));
        return '';
      },
    );

    return out;
  }
}
