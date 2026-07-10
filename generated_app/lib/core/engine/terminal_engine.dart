import 'dart:async';

import '../backend/terminal_backend.dart';
import '../backend/pty_terminal_backend.dart';

import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_state_machine.dart';



class TerminalEngine {


  TerminalEngine({

    TerminalBackend? backend,

    ScreenBuffer? buffer,

  })

      : backend =
            backend ??
            PtyTerminalBackend(),

        buffer =
            buffer ??
            ScreenBuffer()

  {

    vt100 =
        VT100StateMachine(
          this.buffer,
        );

  }







  final TerminalBackend backend;


  final ScreenBuffer buffer;



  final AnsiCsiParser parser =
      AnsiCsiParser();



  late final VT100StateMachine vt100;



  StreamSubscription<String>?
      _outputSubscription;



  StreamSubscription<String>?
      _errorSubscription;



  Function()? onUpdate;



  bool _running = false;



  bool get isRunning =>
      _running;









  Future<void> start()
  async {


    if(_running)
    {
      return;
    }



    _outputSubscription =

        backend.output.listen(

          _handleOutput,

        );





    _errorSubscription =

        backend.errors.listen(

          (error){

            buffer.writeText(

              '\nERROR: $error\n',

            );


            onUpdate?.call();


          },

        );






    await backend.start();



    _running = true;


  }









  void _handleOutput(

    String data,

  )
  {


    final events =

        parser.parse(

          data,

        );







    for(final event in events)

    {

      vt100.handle(
        event,
      );


    }







    onUpdate?.call();


  }









  Future<void> write(

    String text,

  )
  async {


    if(!_running)
    {
      return;
    }




    await backend.write(

      text,

    );


  }









  Future<void> resize(

    int cols,

    int rows,

  )
  async {


    if(!_running)
    {
      return;
    }



    await backend.resize(

      cols,

      rows,

    );


  }









  Future<void> kill()

  async {


    if(!_running)
    {
      return;
    }



    await _outputSubscription
        ?.cancel();



    await _errorSubscription
        ?.cancel();




    await backend.stop();



    _running = false;


  }



}
