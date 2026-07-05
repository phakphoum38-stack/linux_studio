import 'terminal_engine.dart';
import 'screen_buffer.dart';
import 'ansi_parser.dart';

class PtyBridge {
  final TerminalEngine _engine = TerminalEngine();

  late ScreenBuffer buffer;

  final AnsiParser parser = AnsiParser();

  Function()? onRender;

  Future<void> start(ScreenBuffer screen, Function() render) async {
    buffer = screen;
    onRender = render;

    await _engine.start((event) {
      if (event.runtimeType.toString().contains('AnsiCommand')) {
        final cmd = event;

        if (cmd.reset == true) {
          buffer.setColor(fg: 7, bg: 0);
        }

        if (cmd.fg != null || cmd.bg != null) {
          buffer.setColor(fg: cmd.fg, bg: cmd.bg);
        }

        if (cmd.text != null) {
          buffer.write(cmd.text!);
        }

        onRender?.call();
      }
    });
  }

  void write(String input) {
    _engine.write(input);
  }

  void kill() {
    _engine.kill();
  }
}
