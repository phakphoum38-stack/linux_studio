import 'dart:async';
import 'dart:io';

import 'terminal_backend.dart';



class PtyTerminalBackend
    implements TerminalBackend {



  Process? _process;



  final StreamController<String>
      _output =
      StreamController.broadcast();




  @override
  Stream<String> get output =>
      _output.stream;







  @override
  Future<void> start()
  async {


    _process =
        await Process.start(

      'bash',

      [
        '-i'
      ],

      environment: {

        ...Platform.environment,

        'TERM':
          'xterm-256color',

      },

    );




    _process!
        .stdout
        .transform(
          systemEncoding.decoder,
        )
        .listen(
          _output.add,
        );



    _process!
        .stderr
        .transform(
          systemEncoding.decoder,
        )
        .listen(
          _output.add,
        );


  }









  @override
  void write(
    String data,
  ){

    _process?
        .stdin
        .write(
          data,
        );

  }









  @override
  void resize(

    int cols,

    int rows,

  ){


    //
    // ioctl TIOCSWINSZ
    //
    // native PTY resize
    //


  }









  @override
  Future<void> kill()
  async {


    _process?.kill();



    await _output.close();


  }



}
