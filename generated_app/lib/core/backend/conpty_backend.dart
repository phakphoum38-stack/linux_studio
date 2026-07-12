import 'dart:async';
import 'dart:io';

import 'native_terminal.dart';
import 'terminal_backend.dart';


class ConPTYBackend implements TerminalBackend {


  final NativeTerminal terminal =
      NativeTerminal();



  final StreamController<String> _outputController =
      StreamController<String>.broadcast();



  final StreamController<String> _errorController =
      StreamController<String>.broadcast();



  Timer? _reader;



  bool _started = false;





  @override
  Stream<String> get output =>
      _outputController.stream;




  @override
  Stream<String> get errors =>
      _errorController.stream;






  @override
  Future<void> start()
  async {


    if(!Platform.isWindows){

      throw UnsupportedError(
        'ConPTY only works on Windows',
      );

    }



    if(_started){

      return;

    }




    _started =
        await terminal.open();




    if(!_started){

      _errorController.add(
        'Failed to create ConPTY session.',
      );

      return;

    }






    _reader =
        Timer.periodic(

          const Duration(
            milliseconds: 16,
          ),

          (_) {


            if(!_started){

              return;

            }




            try{


              final data =
                  terminal.read();



              if(data.isNotEmpty){

                _outputController.add(
                  data,
                );

              }


            }

            catch(e){

              _errorController.add(
                e.toString(),
              );

            }


          },

        );

  }








  @override
  Future<void> write(
    String text,
  )
  async {


    if(!_started){

      return;

    }



    await terminal.write(
      text,
    );


  }








  @override
  String read(){


    if(!_started){

      return '';

    }



    return terminal.read();


  }








  @override
  Future<void> resize(

    int cols,

    int rows,

  )
  async {


    if(!_started){

      return;

    }



    await terminal.resize(

      cols: cols,

      rows: rows,

    );


  }









  @override
  Future<void> stop()

  async {


    if(!_started){

      return;

    }



    _started = false;



    _reader?.cancel();

    _reader = null;



    await terminal.close();




    await _outputController.close();

    await _errorController.close();


  }



}
