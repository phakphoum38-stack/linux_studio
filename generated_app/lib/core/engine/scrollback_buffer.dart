class ScrollbackBuffer {
  final List<String> lines = [];

  int maxSize = 1000;

  void add(String line) {
    lines.add(line);

    if (lines.length > maxSize) {
      lines.removeAt(0);
    }
  }

  List<String> getVisible(int start, int end) {
    return lines.sublist(start, end.clamp(0, lines.length));
  }
}
