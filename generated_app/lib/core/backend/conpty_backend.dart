import 'dart:io';

import 'terminal_backend.dart';

import 'native_terminal.dart';



class ConPTYBackend
    implements TerminalBackend {


  final StreamController<String> _outputController =
    StreamController<String>.broadcast();

  
  final StreamController<String> _errorController =
    StreamController<String>.broadcast();


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
        terminal.open(
          rows: 24,
          cols: 80,
        );


  }







  @override
  Future<void> write(String text) async {
    _terminal.write(text);
  }


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
  Future<void> resize(int cols, int rows) async {
    _terminal.resize(
      cols: cols,
      rows: rows,
    );
  }


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


    terminal.close();



    started = false;


  }

  @override
  Stream<String> get output =>
      _outputController.stream;

  @override
  Stream<String> get errors =>
      _errorController.stream;


}
