class ScreenBuffer {
  final List<String> _lines = [];

  int maxLines = 500;

  List<String> get lines => _lines;

  void write(String data) {
    final split = data.split('\n');

    for (final line in split) {
      _lines.add(_clean(line));
    }

    _trim();
  }

  void clear() {
    _lines.clear();
  }

  String _clean(String input) {
    return input
        .replaceAll(RegExp(r'\x1B\[[0-9;]*m'), '')
        .replaceAll('\x1B', '');
  }

  void _trim() {
    if (_lines.length > maxLines) {
      _lines.removeRange(0, _lines.length - maxLines);
    }
  }
}
