import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';



typedef TerminalCreateNative =

    Pointer<Void> Function(

      Int32 rows,

      Int32 cols,

    );



typedef TerminalCreate =

    Pointer<Void> Function(

      int rows,

      int cols,

    );







typedef TerminalWriteNative =

    Int32 Function(

      Pointer<Void> handle,

      Pointer<Utf8> data,

      Int32 length,

    );



typedef TerminalWrite =

    int Function(

      Pointer<Void> handle,

      Pointer<Utf8> data,

      int length,

    );







typedef TerminalReadNative =

    Int32 Function(

      Pointer<Void> handle,

      Pointer<Utf8> buffer,

      Int32 size,

    );



typedef TerminalRead =

    int Function(

      Pointer<Void> handle,

      Pointer<Utf8> buffer,

      int size,

    );







typedef TerminalResizeNative =

    Int32 Function(

      Pointer<Void> handle,

      Int32 rows,

      Int32 cols,

    );



typedef TerminalResize =

    int Function(

      Pointer<Void> handle,

      int rows,

      int cols,

    );







typedef TerminalCloseNative =

    Void Function(

      Pointer<Void> handle,

    );



typedef TerminalClose =

    void Function(

      Pointer<Void> handle,

    );









class TerminalFFI {



  TerminalFFI._();



  static final instance =

      TerminalFFI._();





  DynamicLibrary? _dll;



  bool _loaded = false;





  late TerminalCreate _create;



  late TerminalWrite _write;



  late TerminalRead _read;



  late TerminalResize _resize;



  late TerminalClose _close;









  void load()

  {



    if(_loaded)

    {

      return;

    }






    if(!Platform.isWindows)

    {

      throw UnsupportedError(

        'ConPTY only available on Windows',

      );

    }







    _dll =

        DynamicLibrary.open(

          'terminal_api.dll',

        );







    final lib = _dll!;







    _create =

        lib.lookupFunction<

          TerminalCreateNative,

          TerminalCreate

        >(

          'terminal_create',

        );







    _write =

        lib.lookupFunction<

          TerminalWriteNative,

          TerminalWrite

        >(

          'terminal_write',

        );







    _read =

        lib.lookupFunction<

          TerminalReadNative,

          TerminalRead

        >(

          'terminal_read',

        );







    _resize =

        lib.lookupFunction<

          TerminalResizeNative,

          TerminalResize

        >(

          'terminal_resize',

        );







    _close =

        lib.lookupFunction<

          TerminalCloseNative,

          TerminalClose

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



    return _create(

      rows,

      cols,

    );


  }









 bool write(

  Pointer<Void> handle,

  String text,

)

{


  load();



  final ptr =

      text.toNativeUtf8();







  final result =

      _write(

        handle,

        ptr,

        ptr.length,

      );







  calloc.free(

    ptr,

  );







  return result != 0;


} 









  String read(

    Pointer<Void> handle,

    load();

  )

  {



    final buffer =

        calloc<Uint8>(

          4096,

        );





    final result =

        _read(

          handle,

          buffer.cast<Utf8>(),

          4096,

        );






    if(result <= 0)

    {


      calloc.free(buffer);



      return '';

    }







    final text =

        buffer

            .cast<Utf8>()

            .toDartString(

              length: result,

            );






    calloc.free(buffer);



    return text;


  }









  bool resize(

    Pointer<Void> handle,

    int rows,

    int cols,

    load();

  )

  {


    return _resize(

      handle,

      rows,

      cols,

    ) != 0;


  }









  void close(

    Pointer<Void> handle,

    load();

  )

  {


    _close(

      handle,

    );


  }



}