import 'dirty_region.dart';
import 'render_scheduler.dart';

class RenderPipeline {
  final DirtyRegion dirty = DirtyRegion();
  final RenderScheduler scheduler = RenderScheduler();

  void markDirty(int row) {
    dirty.mark(row);
  }

  bool shouldRender() {
    return scheduler.shouldRender() && dirty.isDirty;
  }

  void clear() {
    dirty.clear();
  }
}
