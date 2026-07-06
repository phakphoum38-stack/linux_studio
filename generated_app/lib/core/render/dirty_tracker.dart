import 'dirty_region.dart';

class DirtyTracker {
  final List<DirtyRegion> _regions = [];

  void mark(int x, int y, int w, int h) {
    _regions.add(DirtyRegion(x, y, w, h));
  }

  void clear() {
    _regions.clear();
  }

  List<DirtyRegion> get regions => _regions;
}
