class ScrollbackEngine {
  final List<String> _lines = [];

  final int maxSize;

  ScrollbackEngine({this.maxSize = 5000});

  void add(String line) {
    _lines.add(line);

    if (_lines.length > maxSize) {
      _lines.removeAt(0);
    }
  }

  List<String> getAll() => _lines;

  void clear() {
    _lines.clear();
  }
}
