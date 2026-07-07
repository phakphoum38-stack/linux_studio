import 'dirty_tracker.dart';


class RenderPipeline {

  final DirtyTracker tracker =
      DirtyTracker();



  void invalidateAll() {

    tracker.markAll(
      200,
      200,
    );
  }



  void invalidateCell(
    int row,
    int col,
  ) {

    tracker.mark(
      row,
      col,
    );
  }



  void invalidateRow(
    int row,
    int cols,
  ) {

    tracker.markRow(
      row,
      cols,
    );
  }



  void clear() {

    tracker.clear();
  }
}
