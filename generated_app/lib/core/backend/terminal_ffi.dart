import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';


//
// Native Types
//

typedef TerminalCreateNative = Pointer<Void> Function(
  Int32 rows,
  Int32 cols,
);

typedef TerminalCreate = Pointer<Void> Function(
  int rows,
  int cols,
);



typedef TerminalWriteNative = Bool Function(
  Pointer<Void> handle,
  Pointer<Utf8> data,
  Int32 length,
);

typedef TerminalWrite = bool Function(
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



typedef TerminalResizeNative = Bool Function(
  Pointer<Void> handle,
  Int32 rows,
  Int32 cols,
);

typedef TerminalResize = bool Function(
  Pointer<Void> handle,
  int rows,
  int cols,
);



typedef TerminalCloseNative = Void Function(
  Pointer<Void> handle,
);

typedef TerminalClose = void Function(
  Pointer<Void> handle,
);



//
// Exception
//

class TerminalFFIException implements Exception {

  final String message;

  TerminalFFIException(
    this.message,
  );


  @override
  String toString(){

    return
      'TerminalFFIException: $message';

  }

}



//
// Terminal FFI Loader
//

class TerminalFFI {


  TerminalFFI._();



  static final TerminalFFI instance =
      TerminalFFI._();



  DynamicLibrary? _library;



  bool _loaded = false;



  bool get isLoaded =>
      _loaded;



  late TerminalCreate create;

  late TerminalWrite write;

  late TerminalRead read;

  late TerminalResize resize;

  late TerminalClose close;




  //
  // Load DLL
  //

  void load(){


    if(_loaded){

      return;

    }



    if(!Platform.isWindows){

      throw TerminalFFIException(
        'ConPTY only available on Windows',
      );

    }



    _library =
        _openLibrary();



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




  DynamicLibrary _openLibrary(){


    final names = [

      'terminal_api.dll',

      'terminal.dll',

    ];



    for(final name in names){


      try {


        return DynamicLibrary.open(
          name,
        );


      }

      catch(_){}



    }




    throw TerminalFFIException(
      'terminal_api.dll not found',
    );


  }
