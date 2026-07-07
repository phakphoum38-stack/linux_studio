import 'dart:io';

import 'terminal_backend.dart';



class PtyTerminalBackend
    implements TerminalBackend {



  Process? _process;



  @override
  Function(String data)? onOutput;



  @override
  Function(String error)? onError;







  @override
  Future<void> start()
  async {


    try {


      _process =
          await Process.start(

        'bash',

        [
          '-i',
        ],


        environment: {


          ...Platform.environment,


          'TERM':
              'xterm-256color',


          'COLORTERM':
              'truecolor',


        },


      );







      _process!
          .stdout
          .transform(
            systemEncoding.decoder,
          )
          .listen(

            (data){

              onOutput?.call(
                data,
              );

            },

          );








      _process!
          .stderr
          .transform(
            systemEncoding.decoder,
          )
          .listen(

            (data){

              onOutput?.call(
                data,
              );

            },

          );




    }

    catch(e){

      onError?.call(
        e.toString(),
      );

    }


  }









  @override
  void write(
    String data,
  ){


    if(_process == null){

      return;

    }



    _process!
        .stdin
        .write(
          data,
        );



    _process!
        .stdin
        .flush();


  }









  @override
  void resize(

    int cols,

    int rows,

  ){


    //
    // Phase 16.8.8
    //
    // ioctl(TIOCSWINSZ)
    //
    // real PTY resize
    //


  }









  @override
  Future<void> stop()
  async {


    _process?.kill();



    _process = null;


  }



}
