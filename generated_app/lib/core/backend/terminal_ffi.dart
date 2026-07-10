import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';



class TerminalFFI {


  TerminalFFI._();



  static final TerminalFFI instance =

      TerminalFFI._();






  DynamicLibrary? _library;





  late final Pointer<Void> Function(

      int rows,

      int cols,

  )

  _terminalCreate;






  late final bool Function(

      Pointer<Void>,

      Pointer<Utf8>,

      int,

  )

  _terminalWrite;






  late final int Function(

      Pointer<Void>,

      Pointer<Utf8>,

      int,

  )

  _terminalRead;






  late final bool Function(

      Pointer<Void>,

      int,

      int,

  )

  _terminalResize;






  late final void Function(

      Pointer<Void>,

  )

  _terminalClose;









  bool _loaded = false;









  void load()

  {


    if(_loaded)

    {

      return;

    }






    if(Platform.isWindows)

    {


      _library =

          DynamicLibrary.open(

            'terminal_api.dll',

          );


    }

    else

    {


      _library =

          DynamicLibrary.process();


    }








    final lib = _library!;







    _terminalCreate =

        lib

        .lookupFunction<

            Pointer<Void> Function(

              Int32,

              Int32,

            ),

            Pointer<Void> Function(

              int,

              int,

            )

        >(

          'terminal_create',

        );







    _terminalWrite =

        lib

        .lookupFunction<

            Int32 Function(

              Pointer<Void>,

              Pointer<Utf8>,

              Int32,

            ),

            bool Function(

              Pointer<Void>,

              Pointer<Utf8>,

              int,

            )

        >(

          'terminal_write',

        );







    _terminalRead =

        lib

        .lookupFunction<

            Int32 Function(

              Pointer<Void>,

              Pointer<Utf8>,

              Int32,

            ),

            int Function(

              Pointer<Void>,

              Pointer<Utf8>,

              int,

            )

        >(

          'terminal_read',

        );







    _terminalResize =

        lib

        .lookupFunction<

            Int32 Function(

              Pointer<Void>,

              Int32,

              Int32,

            ),

            bool Function(

              Pointer<Void>,

              int,

              int,

            )

        >(

          'terminal_resize',

        );







    _terminalClose =

        lib

        .lookupFunction<

            Void Function(

              Pointer<Void>,

            ),

            void Function(

              Pointer<Void>,

            )

        >(

          'terminal_close',

        );






    _loaded = true;


  }









  Pointer<Void> create(

    int rows,

    int cols,

  )

  {


    load();



    return _terminalCreate(

      rows,

      cols,

    );


  }









  bool write(

    Pointer<Void> handle,

    String text,

  )

  {


    final ptr =

        text.toNativeUtf8();





    final result =

        _terminalWrite(

          handle,

          ptr,

          text.length,

        );





    calloc.free(ptr);



    return result;


  }









  String read(

    Pointer<Void> handle,

  )

  {


    final buffer =

        calloc<Utf8>(

          4096,

        );





    final length =

        _terminalRead(

          handle,

          buffer,

          4096,

        );





    if(length <= 0)

    {

      calloc.free(buffer);

      return '';

    }





    final result =

        buffer

        .toDartString(

          length:length,

        );





    calloc.free(buffer);



    return result;


  }









  bool resize(

    Pointer<Void> handle,

    int cols,

    int rows,

  )

  {


    return _terminalResize(

      handle,

      rows,

      cols,

    );


  }









  void close(

    Pointer<Void> handle,

  )

  {


    _terminalClose(

      handle,

    );


  }



}
