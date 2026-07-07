import '../engine/screen_buffer.dart';
import '../engine/terminal_engine.dart';

import '../backend/terminal_backend.dart';


class TerminalController {


  final ScreenBuffer buffer;


  final TerminalEngine engine;


  Function()? onUpdate;



  TerminalController({

    required this.buffer,

    required TerminalBackend backend,

  }) :

    engine =
      TerminalEngine(
        backend: backend,
        buffer: buffer,
      );







  Future<void> start()
  async {


    engine.onUpdate =
        () {

      onUpdate?.call();

    };


    await engine.start();


  }







  void write(
    String text,
  ){

    engine.write(
      text,
    );

  }








  void sendKey(
    String key,
  ){

    engine.sendKey(
      key,
    );

  }







  void resize(
    int cols,
    int rows,
  ){

    engine.resize(
      cols,
      rows,
    );

  }








  Future<void> stop()
  async {


    await engine.kill();


  }


}
