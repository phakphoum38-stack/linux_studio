import 'dart:async';

import 'native_terminal.dart';

import 'terminal_backend.dart';



class WindowsTerminalBackend

    implements TerminalBackend {



  final NativeTerminal terminal;



  final StreamController<String>

      _output =

      StreamController<String>.broadcast();





  final StreamController<String>

      _errors =

      StreamController<String>.broadcast();





  Timer? _reader;



  bool _running = false;









  WindowsTerminalBackend({

    NativeTerminal? native,

  })

      :

        terminal =

            native ??

            NativeTerminal();









  @override

  Stream<String> get output =>

      _output.stream;









  @override

  Stream<String> get errors =>

      _errors.stream;









  @override

  Future<void> start()

  async {


    if(_running)

    {

      return;

    }






    final result =

        await terminal.start(

          rows: 24,

          cols: 80,

        );







    if(!result)

    {

      _errors.add(

        'Cannot start Windows ConPTY',

      );


      return;

    }







    _running = true;







    _reader =

        Timer.periodic(

          const Duration(

            milliseconds: 30,

          ),

          (_) {


            if(!_running)

            {

              return;

            }







            final data =

                terminal.read();






            if(data.isNotEmpty)

            {

              _output.add(

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


    await terminal.write(

      text,

    );


  }









  @override

  String read()

  {


    return terminal.read();


  }









  @override

  Future<void> resize(

    int cols,

    int rows,

  )

  async {


    await terminal.resize(

      cols: cols,

      rows: rows,

    );


  }









  @override

  Future<void> stop()

  async {


    _running = false;



    _reader?.cancel();



    _reader = null;





    terminal.close();



  }



}
