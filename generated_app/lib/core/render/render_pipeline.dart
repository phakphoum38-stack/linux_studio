import '../engine/screen_buffer.dart';

class RenderPipeline {
  final ScreenBuffer buffer;

  RenderPipeline(this.buffer);

  void render() {
    // Phase 14: placeholder safe pipeline
    // (no DirtyRegion / DirtyTracker yet)
  }
}
