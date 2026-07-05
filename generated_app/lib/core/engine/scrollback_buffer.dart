class ScrollbackBuffer {
  final int maxLines;

  final List<String> _lines = [];

  ScrollbackBuffer({this.maxLines = 2000});

  List<String> get lines => _lines;

  void add(String line) {
    _lines.add(line);

    if (_lines.length > maxLines) {
      _lines.removeAt(0);
    }
  }

  void clear() {
    _lines.clear();
  }
}
