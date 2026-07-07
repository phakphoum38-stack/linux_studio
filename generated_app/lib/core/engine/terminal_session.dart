import 'terminal_engine.dart';
import 'screen_buffer.dart';
import 'scrollback_buffer.dart';
import 'diff_renderer.dart';

class TerminalSession {
  final TerminalEngine engine = TerminalEngine();

  late ScreenBuffer screen;

  final ScrollbackBuffer scrollback =
      ScrollbackBuffer();

  final DiffRenderer diff =
      DiffRenderer();

  Function()? onUpdate;


  Future<void> start(
    ScreenBuffer buffer,
    Function() render,
  ) async {

    screen = buffer;

    onUpdate = render;


    await engine.start(
      (event) {

        String? text;


        if (event is String) {
          text = event;
        }
        else if (event.text != null) {
          text = event.text;
        }


        if (text != null && text.isNotEmpty) {

          screen.writeText(
            text,
          );


          scrollback.add(
            text,
          );


          onUpdate?.call();
        }
      },
    );
  }


  void write(
    String input,
  ) {
    if (input.isEmpty) {
      return;
    }

    engine.write(
      input,
    );
  }


  void kill() {
    engine.kill();
  }
}
