import 'terminal_backend.dart';
import 'package:flutter_pty/flutter_pty.dart';



class PtyTerminalBackend
    implements TerminalBackend {



  Pty? _pty;



  @override
  Function(String data)? onOutput;



  @override
  Function(String error)? onError;





  @override
  Future<void> start()
  async {


    try {


      _pty =
          Pty.start(
            "/bin/bash",

            arguments:[
              "-i",
            ],


            environment:{

              "TERM":
                "xterm-256color",

            },


            columns:80,

            rows:24,

          );




      _pty!
          .output
          .listen((data){

        onOutput?.call(
          String.fromCharCodes(data),
        );

      });



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

    _pty?.input.add(
      data.codeUnits,
    );

  }






  @override
  void resize(
    int cols,
    int rows,
  ){

    _pty?.resize(
      rows,
      cols,
    );

  }







  @override
  Future<void> stop()
  async {

    await _pty?.kill();

  }


}
