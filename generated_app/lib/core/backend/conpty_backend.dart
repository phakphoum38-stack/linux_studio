import 'dart:io';

import 'terminal_backend.dart';

import 'native_terminal.dart';



class ConPTYBackend
    implements TerminalBackend {



  final NativeTerminal terminal =
      NativeTerminal();





  bool started = false;






  @override
  Future<void> start()

  async {


    if(!Platform.isWindows){

      throw UnsupportedError(
        'ConPTY only works on Windows',
      );

    }



    started =
        terminal.create(
          rows: 24,
          cols: 80,
        );


  }







  @override
  void write(
    String data,
  ){


    if(!started){

      return;

    }



    terminal.write(
      data,
    );


  }








  @override
  String read(){


    if(!started){

      return '';

    }



    return terminal.read();


  }







  @override
  void resize(
    int cols,
    int rows,
  ){


    if(!started){

      return;

    }



    terminal.resize(
      rows,
      cols,
    );


  }








  @override
  Future<void> stop()

  async {


    terminal.dispose();



    started = false;


  }


}
