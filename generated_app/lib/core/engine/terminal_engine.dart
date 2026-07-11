import 'dart:async';

import '../backend/terminal_backend.dart';

import 'screen_buffer.dart';

import 'ansi_csi_parser.dart';

import 'vt100_controller.dart';





class TerminalEngine {



  final TerminalBackend backend;



  final ScreenBuffer buffer;



  late final VT100Controller vt100;



  final AnsiCsiParser parser =

      AnsiCsiParser();





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

            ScreenBuffer()

  {


    vt100 =

        VT100Controller(

          buffer: this.buffer,

        );


  }









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



    await backend.resize(

      cols,

      rows,

    );


  }









  Future<void> kill()

  async {


    await _outputSubscription

        ?.cancel();






    await backend.stop();






    _running = false;


  }



}