import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'terminal_ffi.dart';




class NativeTerminal {



  late final TerminalBindings _api;



  bool _loaded = false;



  Pointer<Void>? _handle;







  NativeTerminal(){


    _load();


  }








  void _load(){



    if(!Platform.isWindows){

      return;

    }




    try{


      final dll =
          DynamicLibrary.open(
            'terminal_api.dll',
          );



      _api =
          TerminalBindings(
            dll,
          );



      _loaded = true;



    }

    catch(e){


      _loaded = false;


    }


  }









  bool create({

    int rows = 24,

    int cols = 80,

  }){


    if(!_loaded){

      return false;

    }



    final result =
        _api.terminal_create(

          rows,

          cols,

        );



    _handle =
        result;



    return
        _handle != nullptr;


  }









  void write(

    String data,

  ){


    if(!_loaded ||
       _handle == nullptr){

      return;

    }



    final ptr =
        data.toNativeUtf8();



    _api.terminal_write(

      _handle!,

      ptr.cast(),

      data.length,

    );



    calloc.free(
      ptr,
    );


  }









  String read(){



    if(!_loaded ||
       _handle == nullptr){

      return '';

    }





    final buffer =
        calloc<Uint8>(
          8192,
        );



    final size =
        _api.terminal_read(

          _handle!,

          buffer.cast(),

          8192,

        );





    if(size <= 0){


      calloc.free(
        buffer,
      );


      return '';

    }





    final data =
        String.fromCharCodes(

          buffer
              .asTypedList(size),

        );



    calloc.free(
      buffer,
    );



    return data;


  }









  void resize(

    int rows,

    int cols,

  ){


    if(!_loaded ||
       _handle == nullptr){

      return;

    }



    _api.terminal_resize(

      _handle!,

      rows,

      cols,

    );


  }









  void dispose(){


    if(!_loaded ||
       _handle == nullptr){

      return;

    }



    _api.terminal_close(

      _handle!,

    );



    _handle =
        nullptr;


  }



}
