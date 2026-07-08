import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_state_machine.dart';

import '../backend/pty_terminal_backend.dart';
import '../backend/terminal_backend.dart';



class TerminalEngine {


  final TerminalBackend backend;


  final ScreenBuffer buffer;


  final AnsiCsiParser parser =
      AnsiCsiParser();



  late final VT100StateMachine vt100;



  Function()? onUpdate;




  TerminalEngine({

    TerminalBackend? backend,

    ScreenBuffer? buffer,

  })  : backend = backend ?? PtyTerminalBackend(),
        buffer = buffer ?? ScreenBuffer() {


    vt100 =
        VT100StateMachine(
          this.buffer,
        );


  }








  Future<void> start([
    Function(dynamic event)? onOutput,
  ])
  async {



    backend.onOutput =
        (data) {
      _handleOutput(data);
      onOutput?.call(data);
    };



    backend.onError =
        (error){


      buffer.writeText(
        "\nERROR: $error\n",
      );


      onUpdate?.call();


    };



    await backend.start();


  }









  void _handleOutput(
    String data,
  ){


    final events =
        parser.parse(
          data,
        );



    for(final event in events){


      vt100.handle(
        event,
      );


    }



    onUpdate?.call();


  }









  void write(
    String input,
  ){


    backend.write(
      input,
    );


  }








  void sendKey(
    String key,
  ){

    write(
      key,
    );

  }








  void resize(
    int cols,
    int rows,
  ){


    backend.resize(
      cols,
      rows,
    );


  }









  Future<void> kill()
  async {


    await backend.stop();


  }



}
