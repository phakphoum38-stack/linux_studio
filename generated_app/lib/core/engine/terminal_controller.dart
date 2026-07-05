import 'screen_buffer.dart';
import 'terminal_engine.dart';
import 'selection_engine.dart';
import 'input_pipeline.dart';

class TerminalController {
  final TerminalEngine engine = TerminalEngine();
  final InputPipeline input = InputPipeline();
  final SelectionEngine selection = SelectionEngine();

  late ScreenBuffer buffer;

  Function()? onUpdate;

  Future<void> start(ScreenBuffer screen, Function() render) async {
    buffer = screen;
    onUpdate = render;

    await engine.start((event) {
      if (event is String) {
        buffer.write(event);
        onUpdate?.call();
      }
    });
  }

  void send(String text) {
    engine.write(text);
  }

  void paste(String text) {
    input.add(text);
    engine.write(input.flush());
  }

  void stop() {
    engine.kill();
  }
}
