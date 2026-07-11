import 'dart:async';

import 'dart:convert';

import 'dart:io';

import 'terminal_backend.dart';





class PtyTerminalBackend

    implements TerminalBackend {





  Process? _process;





  final StreamController<String>

      _outputController =

      StreamController<String>.broadcast();





  final StreamController<String>

      _errorController =

      StreamController<String>.broadcast();





  bool _running = false;



  bool get isRunning =>

      _running;









  @override

  Stream<String> get output =>

      _outputController.stream;









  @override

  Stream<String> get errors =>

      _errorController.stream;









  @override

  Future<void> start()

  async {


    if(_running)

    {

      return;

    }







    try

    {


      _process =

          await Process.start(

            '/bin/bash',

            [

              '-i'

            ],

          );







      _running = true;









      _process!

          .stdout

          .transform(

            utf8.decoder,

          )

          .listen(

            (data)

            {


              _outputController.add(

                data,

              );


            },

          );









      _process!

          .stderr

          .transform(

            utf8.decoder,

          )

          .listen(

            (data)

            {


              _errorController.add(

                data,

              );


            },

          );



    }

    catch(e)

    {


      _errorController.add(

        e.toString(),

      );


    }



  }









  @override

  Future<void> write(

    String text,

  )

  async {


    if(!_running ||

       _process == null)

    {

      return;

    }







    _process!

        .stdin

        .write(

          text,

        );



  }









  @override

  String read()

  {


    return '';

  }









  @override

  Future<void> resize(

    int cols,

    int rows,

  )

  async {


    // Linux PTY resize
    // เชื่อม native ioctl TIOCSWINSZ ภายหลัง


  }









  @override

  Future<void> stop()

  async {


    if(!_running)

    {

      return;

    }







    _running = false;







    _process?.kill(

      ProcessSignal.sigkill,

    );







    _process = null;



  }









  Future<void> dispose()

  async {


    await stop();





    await _outputController.close();



    await _errorController.close();


  }



}