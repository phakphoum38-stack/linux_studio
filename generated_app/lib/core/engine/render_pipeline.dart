import '../render/diff_renderer.dart';
import 'screen_buffer.dart';

class RenderPipeline {
  final DiffRenderer diff = DiffRenderer();

  List<dynamic> render(ScreenBuffer buffer) {
    final changes = diff.diff(buffer.buffer);

    return changes;
  }
}
