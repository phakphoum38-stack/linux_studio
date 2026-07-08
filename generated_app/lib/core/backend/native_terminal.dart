import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'terminal_ffi.dart';





class NativeTerminal {


  final TerminalFFI ffi;



  Pointer<Void>? _handle;





  NativeTerminal()

      : ffi = TerminalFFI();








  bool create({

    int rows = 24,

    int cols = 80,

  }){


    _handle =
        ffi.create(
          rows,
          cols,
        );


    return
        _handle != nullptr;


  }







  bool write(
    String text,
  ){


    if(
      _handle == null
    ){

      return false;

    }



    final data =
        text.toNativeUtf8();



    final result =
        ffi.write(
          _handle!,
          data,
          text.length,
        );



    calloc.free(
      data,
    );



    return result;


  }








  String read(){


    if(
      _handle == null
    ){

      return '';

    }



    final buffer =
        calloc<Uint8>(
          4096,
        )
        .cast<Utf8>();



    final size =
        ffi.read(
          _handle!,
          buffer,
          4096,
        );



    final output =
        size > 0
            ? buffer.toDartString(
                length:size,
              )
            : '';



    calloc.free(
      buffer,
    );


    return output;


  }








  bool resize(
    int rows,
    int cols,
  ){


    if(
      _handle == null
    ){

      return false;

    }



    return ffi.resize(
      _handle!,
      rows,
      cols,
    );


  }








  void dispose(){


    if(
      _handle != null
    ){

      ffi.close(
        _handle!,
      );


      _handle = null;

    }


  }


}
