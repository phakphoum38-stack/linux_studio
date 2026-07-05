import 'diff_renderer.dart';
import 'screen_buffer.dart';

class RenderPipeline {
  final DiffRenderer diff = DiffRenderer();

  List<dynamic> render(ScreenBuffer buffer) {
    final changes = diff.compute(buffer.buffer);

    return changes;
  }
}
