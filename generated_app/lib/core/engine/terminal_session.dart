import 'terminal_engine.dart';
import 'screen_buffer.dart';
import 'scrollback_buffer.dart';
import 'diff_renderer.dart';

class TerminalSession {
  final TerminalEngine engine = TerminalEngine();

  late ScreenBuffer screen;
  final ScrollbackBuffer scrollback = ScrollbackBuffer();
  final DiffRenderer diff = DiffRenderer();

  Function()? onUpdate;

  Future<void> start(ScreenBuffer buffer, Function() render) async {
    screen = buffer;
    onUpdate = render;

    await engine.start((event) {
      // text stream only for now
      if (event.text != null) {
        screen.write(event.text!);
        scrollback.add(event.text!);
        onUpdate?.call();
      }
    });
  }

  void write(String input) {
    engine.write(input);
  }

  void kill() {
    engine.kill();
  }
}
