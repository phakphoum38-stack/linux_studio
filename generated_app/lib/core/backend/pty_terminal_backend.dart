import 'dart:async';

import 'terminal_backend.dart';
import 'native_terminal.dart';



class PtyTerminalBackend
    implements TerminalBackend {



  final NativeTerminal _terminal =
      NativeTerminal();



  Timer? _reader;



  bool _running = false;



  final StreamController<String> _output =
      StreamController<String>.broadcast();



  Stream<String> get output =>
      _output.stream;








  @override
  Future<void> start()

  async {


    final created =
        _terminal.create(
          rows: 24,
          cols: 80,
        );



    if(!created){

      throw Exception(
        'Failed to create ConPTY session',
      );

    }



    _running = true;



    _reader =
        Timer.periodic(

          const Duration(
            milliseconds: 30,
          ),

          (_) {


            if(!_running){

              return;

            }



            final data =
                _terminal.read();



            if(data.isNotEmpty){

              _output.add(
                data,
              );

            }


          },

        );


  }








  @override
  void write(

    String data,

  ){


    if(!_running){

      return;

    }



    _terminal.write(
      data,
    );


  }








  @override
  String read(){


    return _terminal.read();


  }








  @override
  void resize(

    int cols,

    int rows,

  ){


    if(!_running){

      return;

    }



    _terminal.resize(

      rows,

      cols,

    );


  }








  @override
  Future<void> stop()

  async {


    _running = false;



    _reader?.cancel();



    _reader = null;



    _terminal.dispose();



    await _output.close();


  }



}
