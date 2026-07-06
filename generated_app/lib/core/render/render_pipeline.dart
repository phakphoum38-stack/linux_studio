import 'dirty_tracker.dart';

class RenderPipeline {
  final DirtyTracker tracker = DirtyTracker();

  void invalidateAll() {
    tracker.clear();
  }

  void invalidateCell(int r, int c) {
    tracker.mark(r, c);
  }
}
