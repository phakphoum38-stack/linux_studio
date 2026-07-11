import 'dart:ffi';

import 'terminal_ffi.dart';





class NativeTerminal {



  Pointer<Void>? _handle;



  bool _running = false;





  bool get isRunning =>

      _running;




  Future<bool> open({
    int rows = 24,
    int cols = 80,
  }) async {
    return start(
      rows: rows,
      cols: cols,
   );
  }









  Future<bool> start({

    int rows = 24,

    int cols = 80,

  })

  async {


    if(_running)

    {

      return true;

    }







    final handle =

        TerminalFFI.instance.create(

          rows,

          cols,

        );







    if(handle == nullptr)

    {

      return false;

    }







    _handle = handle;



    _running = true;



    return true;


  }









  String read()

  {


    if(!_running ||

       _handle == null)

    {

      return '';

    }







    return TerminalFFI.instance.read(

      _handle!,

    );


  }









  Future<void> write(

    String text,

  )

  async {


    if(!_running ||

       _handle == null ||

       text.isEmpty)

    {

      return;

    }







    TerminalFFI.instance.write(

      _handle!,

      text,

    );


  }









  Future<void> resize({

    required int cols,

    required int rows,

  })

  async {


    if(!_running ||

       _handle == null)

    {

      return;

    }







    TerminalFFI.instance.resize(

      _handle!,

      rows,

      cols,

    );


  }









  Future<void> close()

  async {


    if(!_running ||

       _handle == null)

    {

      return;

    }







    TerminalFFI.instance.close(

      _handle!,

    );







    _handle = null;



    _running = false;


  }









  Future<void> dispose()

  async {


    await close();


  }



}
