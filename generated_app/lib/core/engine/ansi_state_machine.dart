class AnsiStateMachine {
  String buffer = '';

  Function(String text)? onText;
  Function(String code, List<int> params)? onCommand;

  void feed(String input) {
    buffer += input;

    final regex = RegExp(r'\x1b\[([0-9;]*)?([A-Za-z])');

    buffer.splitMapJoin(
      regex,
      onMatch: (m) {
        final code = m.group(2)!;
        final raw = m.group(1) ?? '';

        final params =
            raw.isEmpty ? <int>[] : raw.split(';').map(int.parse).toList();

        onCommand?.call(code, params);
        return '';
      },
      onNonMatch: (t) {
        onText?.call(t);
        return '';
      },
    );
  }
}
