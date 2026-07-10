import 'dart:async';
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



    try {


      if(Platform.isWindows)

      {


        _process =

            await Process.start(

              'cmd.exe',

              [],

              runInShell:true,

            );


      }

      else

      {


        _process =

            await Process.start(

              '/bin/bash',

              [

                '-i'

              ],

            );


      }






      _running = true;





      _process!
          .stdout
          .transform(
            const SystemEncoding()
                .decoder,
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
            const SystemEncoding()
                .decoder,
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


    // Native ConPTY resize
    // จะเชื่อม FFI ในขั้นต่อไป


  }









  @override
  Future<void> stop()

  async {


    _running = false;



    _process?.kill();



    _process = null;



    await _outputController.close();



    await _errorController.close();


  }



}
