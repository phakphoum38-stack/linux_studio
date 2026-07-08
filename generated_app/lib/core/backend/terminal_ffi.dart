import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';





typedef TerminalCreateNative = Pointer<Void> Function(
  Int32 rows,
  Int32 cols,
);


typedef TerminalCreate =
    Pointer<Void> Function(
      int rows,
      int cols,
    );








typedef TerminalWriteNative = Int32 Function(
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








typedef TerminalReadNative = Int32 Function(
  Pointer<Void> handle,
  Pointer<Uint8> buffer,
  Int32 size,
);


typedef TerminalRead =
    int Function(
      Pointer<Void> handle,
      Pointer<Uint8> buffer,
      int size,
    );








typedef TerminalResizeNative = Int32 Function(
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








typedef TerminalCloseNative = Void Function(
  Pointer<Void> handle,
);


typedef TerminalClose =
    void Function(
      Pointer<Void> handle,
    );









class TerminalFFI {



  late final DynamicLibrary library;



  late final TerminalCreate create;

  late final TerminalWrite write;

  late final TerminalRead read;

  late final TerminalResize resize;

  late final TerminalClose close;







  TerminalFFI(){



    if(!Platform.isWindows){

      throw UnsupportedError(
        'ConPTY requires Windows',
      );

    }





    library =
        DynamicLibrary.open(
          'terminal_api.dll',
        );







    create =
        library.lookupFunction<
          TerminalCreateNative,
          TerminalCreate
        >(
          'terminal_create',
        );







    write =
        library.lookupFunction<
          TerminalWriteNative,
          TerminalWrite
        >(
          'terminal_write',
        );







    read =
        library.lookupFunction<
          TerminalReadNative,
          TerminalRead
        >(
          'terminal_read',
        );







    resize =
        library.lookupFunction<
          TerminalResizeNative,
          TerminalResize
        >(
          'terminal_resize',
        );







    close =
        library.lookupFunction<
          TerminalCloseNative,
          TerminalClose
        >(
          'terminal_close',
        );



  }



}
