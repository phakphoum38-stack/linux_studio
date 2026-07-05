class TerminalControllerV5 {
  final DirtyTracker dirty = DirtyTracker();

  void mark(int r, int c) {
    dirty.mark(r, c);
  }

  void scrollEvent() {
    dirty.clear(); // full repaint on scroll
  }
}
