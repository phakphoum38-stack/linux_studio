import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';



typedef TerminalCreateNative = Pointer<Void> Function(
  Int32 rows,
  Int32 cols,
);


typedef TerminalCreate = Pointer<Void> Function(
  int rows,
  int cols,
);





typedef TerminalWriteNative = Int32 Function(
  Pointer<Void> handle,
  Pointer<Utf8> data,
  Int32 length,
);


typedef TerminalWrite = int Function(
  Pointer<Void> handle,
  Pointer<Utf8> data,
  int length,
);





typedef TerminalReadNative = Int32 Function(
  Pointer<Void> handle,
  Pointer<Uint8> buffer,
  Int32 size,
);


typedef TerminalRead = int Function(
  Pointer<Void> handle,
  Pointer<Uint8> buffer,
  int size,
);





typedef TerminalResizeNative = Int32 Function(
  Pointer<Void> handle,
  Int32 cols,
  Int32 rows,
);


typedef TerminalResize = int Function(
  Pointer<Void> handle,
  int cols,
  int rows,
);





typedef TerminalCloseNative = Void Function(
  Pointer<Void> handle,
);


typedef TerminalClose = void Function(
  Pointer<Void> handle,
);








class TerminalFFI {


  TerminalFFI._();



  static final TerminalFFI instance =
      TerminalFFI._();





  DynamicLibrary?
      _library;



  bool _loaded = false;



  bool get isLoaded =>
      _loaded;





  late TerminalCreate create;

  late TerminalWrite write;

  late TerminalRead read;

  late TerminalResize resize;

  late TerminalClose close;








  void load(){


    if(_loaded){
      return;
    }



    if(!Platform.isWindows){

      throw UnsupportedError(
        'Only Windows ConPTY supported',
      );

    }







    _library =
        DynamicLibrary.open(
          'terminal_api.dll',
        );







    create =
        _library!
            .lookupFunction<
              TerminalCreateNative,
              TerminalCreate
            >(
              'terminal_create',
            );







    write =
        _library!
            .lookupFunction<
              TerminalWriteNative,
              TerminalWrite
            >(
              'terminal_write',
            );







    read =
        _library!
            .lookupFunction<
              TerminalReadNative,
              TerminalRead
            >(
              'terminal_read',
            );







    resize =
        _library!
            .lookupFunction<
              TerminalResizeNative,
              TerminalResize
            >(
              'terminal_resize',
            );







    close =
        _library!
            .lookupFunction<
              TerminalCloseNative,
              TerminalClose
            >(
              'terminal_close',
            );






    _loaded = true;


  }


}
