import 'dart:async';

import 'native_terminal.dart';
import 'terminal_backend.dart';



class WindowsTerminalBackend

    implements TerminalBackend {



  final NativeTerminal native;



  final StreamController<String>

      _outputController =

      StreamController<String>.broadcast();





  final StreamController<String>

      _errorController =

      StreamController<String>.broadcast();





  Timer? _readerTimer;



  bool _running = false;









  WindowsTerminalBackend({

    NativeTerminal? terminal,

  })

      :

        native =

            terminal ??

            NativeTerminal();









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






    final ok =

        await native.start();



    if(!ok)

    {

      _errorController.add(

        'Unable to start ConPTY',

      );

      return;

    }






    _running = true;






    _readerTimer =

        Timer.periodic(

          const Duration(

            milliseconds: 30,

          ),

          (_) {


            final data =

                native.read();



            if(data.isNotEmpty)

            {

              _outputController.add(

                data,

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


    await native.write(

      text,

    );


  }









  @override

  String read()

  {


    return native.read();


  }









  @override

  Future<void> resize(

    int cols,

    int rows,

  )

  async {


    await native.resize(

      cols: cols,

      rows: rows,

    );


  }









  @override

  Future<void> stop()

  async {


    _running = false;



    _readerTimer?.cancel();



    _readerTimer = null;




    native.close();



    await _outputController.close();



    await _errorController.close();


  }



}
