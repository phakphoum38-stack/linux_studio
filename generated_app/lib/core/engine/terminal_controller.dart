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


  Future<void> start(
    ScreenBuffer screen,
    Function() render,
  ) async {
    buffer = screen;

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

          buffer.writeText(
            text,
          );

          onUpdate?.call();
        }
      },
    );
  }


  /// Send keyboard input
  void send(
    String text,
  ) {
    if (text.isEmpty) {
      return;
    }

    engine.write(
      text,
    );
  }


  /// Paste text
  void paste(
    String text,
  ) {
    if (text.isEmpty) {
      return;
    }


    input.add(
      text,
    );


    final data = input.flush();


    if (data.isNotEmpty) {

      engine.write(
        data,
      );
    }
  }


  /// Force UI refresh
  void refresh() {
    onUpdate?.call();
  }


  /// Stop terminal
  void stop() {
    engine.kill();
  }
}
