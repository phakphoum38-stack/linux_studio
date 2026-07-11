import 'dart:async';

import '../backend/terminal_backend.dart';

import 'screen_buffer.dart';

import 'ansi_csi_parser.dart';

import 'vt100_controller.dart';





class TerminalEngine {



  final TerminalBackend backend;



  final ScreenBuffer buffer;



  final AnsiCsiParser parser =

      AnsiCsiParser();





  final VT100Controller vt100 =

      VT100Controller();





  Function()? onUpdate;





  StreamSubscription<String>?

      _outputSubscription;





  bool _running = false;



  bool get isRunning =>

      _running;









  TerminalEngine({

    required this.backend,

    ScreenBuffer? buffer,

  })

      :

        buffer =

            buffer ??

            ScreenBuffer();









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

        buffer,

      );


    }







    onUpdate?.call();



  }









  void write(

    String text,

  )

  {


    if(!_running)

    {

      return;

    }



    backend.write(

      text,

    );


  }









  void resize(

    int cols,

    int rows,

  )

  {


    backend.resize(

      cols,

      rows,

    );


  }









  Future<void> kill()

  async {


    await _outputSubscription?.cancel();






    await backend.stop();






    _running = false;



  }



}
