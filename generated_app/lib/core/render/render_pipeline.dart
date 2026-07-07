import 'dirty_tracker.dart';

/// Render invalidation pipeline.
///
/// ควบคุมพื้นที่ที่ต้อง repaint
/// โดยใช้ DirtyTracker เก็บตำแหน่งที่เปลี่ยน
class RenderPipeline {
  final DirtyTracker tracker;

  RenderPipeline({
    DirtyTracker? tracker,
  }) : tracker = tracker ?? DirtyTracker();

  /// Mark entire screen dirty
  void invalidateAll() {
    tracker.clear();
    tracker.markAll();
  }

  /// Mark one cell dirty
  void invalidateCell(
    int row,
    int col,
  ) {
    tracker.mark(
      row,
      col,
    );
  }

  /// Mark one row dirty
  void invalidateRow(
    int row,
  ) {
    tracker.markRow(row);
  }

  /// Get dirty cells
  List<dynamic> get dirtyCells =>
      tracker.dirtyCells;

  /// Reset dirty state
  void clear() {
    tracker.clear();
  }
}
