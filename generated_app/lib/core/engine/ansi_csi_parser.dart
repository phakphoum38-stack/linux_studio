class CsiEvent {
  final String type;
  final List<int> params;

  CsiEvent(this.type, this.params);
}

class AnsiCsiParser {
  final RegExp _regex = RegExp(r'\x1b\[([0-9;]*)?([A-Za-z])');

  List<dynamic> parse(String input) {
    final List<dynamic> out = [];

    input.splitMapJoin(
      _regex,
      onMatch: (m) {
        final cmd = m.group(2)!;
        final raw = m.group(1) ?? '';

        final params = raw.isEmpty
            ? <int>[]
            : raw.split(';').map(int.parse).toList();

        out.add(CsiEvent(cmd, params));
        return '';
      },
      onNonMatch: (text) {
        out.add(text);
        return '';
      },
    );

    return out;
  }
}
