import 'package:flutter/foundation.dart';

/// Simple Dirty Region
/// (แทน dirty_region.dart ที่หายไป)
class DirtyRegion {
  int startRow;
  int endRow;

  DirtyRegion({
    required this.startRow,
    required this.endRow,
  });

  void expand(int row) {
    if (row < startRow) startRow = row;
    if (row > endRow) endRow = row;
  }
}

/// Dirty Tracker
class DirtyTracker {
  DirtyRegion region;

  DirtyTracker(int rows)
      : region = DirtyRegion(startRow: 0, endRow: rows - 1);

  void markAllDirty(int rows) {
    region.startRow = 0;
    region.endRow = rows - 1;
  }

  void markRowDirty(int row) {
    region.expand(row);
  }

  void clear() {
    region.startRow = 0;
    region.endRow = 0;
  }
}

/// Render Pipeline (Simplified for Release 1.0)
class RenderPipeline {
  final int rows;
  final int cols;

  final DirtyTracker dirty;

  RenderPipeline({
    required this.rows,
    required this.cols,
  }) : dirty = DirtyTracker(rows);

  /// Mark full screen dirty
  void invalidateAll() {
    dirty.markAllDirty(rows);
  }

  /// Mark single row dirty
  void invalidateRow(int row) {
    dirty.markRowDirty(row);
  }

  /// Consume dirty region
  DirtyRegion consume() {
    final region = dirty.region;
    dirty.clear();
    return region;
  }

  /// Debug helper
  void debugPrint() {
    debugPrint(
      'Dirty region: ${dirty.region.startRow} - ${dirty.region.endRow}',
    );
  }
}
