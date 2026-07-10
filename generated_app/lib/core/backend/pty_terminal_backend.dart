import 'dart:async';

import 'native_terminal.dart';
import 'terminal_backend.dart';


class PtyTerminalBackend
    implements TerminalBackend {


  PtyTerminalBackend();



  final NativeTerminal terminal =
      NativeTerminal();



  final StreamController<String>
      _output =
      StreamController<String>.broadcast();



  final StreamController<String>
      _errors =
      StreamController<String>.broadcast();



  Timer? _reader;



  bool _running = false;



  @override
  Stream<String> get output =>
      _output.stream;



  @override
  Stream<String> get errors =>
      _errors.stream;





  @override
  Future<void> start()
  async {

    if(_running){
      return;
    }



    final result =
        terminal.open();



    if(!result){

      _errors.add(
        'Unable to start ConPTY',
      );

      return;

    }



    _running = true;



    _reader =
        Timer.periodic(

          const Duration(
            milliseconds: 16,
          ),

          (_) {

            _readOutput();

          },

        );


  }






  void _readOutput(){

    if(!_running){
      return;
    }



    try {

      final data =
          terminal.read();



      if(data.isNotEmpty){

        _output.add(
          data,
        );

      }


    }

    catch(e){

      _errors.add(
        e.toString(),
      );

    }

  }








  @override
  Future<void> write(
    String text,
  )
  async {

    if(!_running){
      return;
    }


    terminal.write(
      text,
    );

  }







  @override
  String read(){

    return terminal.read();

  }







  @override
  Future<void> resize(
    int cols,
    int rows,
  )
  async {


    if(!_running){
      return;
    }



    terminal.resize(
      cols: cols,
      rows: rows,
    );


  }








  @override
  Future<void> stop()
  async {


    _running=false;



    _reader?.cancel();

    _reader=null;



    terminal.close();



    await _output.close();

    await _errors.close();


  }



}
