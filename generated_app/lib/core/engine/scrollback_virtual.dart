class ScrollbackVirtual {
  final List<String> _lines = [];

  int maxLines = 5000;
  int viewOffset = 0;

  void add(String line) {
    _lines.add(line);

    if (_lines.length > maxLines) {
      _lines.removeAt(0);
    }
  }

  List<String> getVisible(int height) {
    final start = (_lines.length - height - viewOffset)
        .clamp(0, _lines.length);

    final end = (_lines.length - viewOffset)
        .clamp(0, _lines.length);

    return _lines.sublist(start, end);
  }

  void scroll(int delta) {
    viewOffset = (viewOffset + delta)
        .clamp(0, _lines.length);
  }
}
