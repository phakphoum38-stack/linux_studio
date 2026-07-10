import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'terminal_ffi.dart';


class NativeTerminal {


  NativeTerminal({
    this.rows = 24,
    this.cols = 80,
  });



  final int rows;
  final int cols;



  Pointer<Void>? _handle;



  bool get isOpen =>
      _handle != null &&
      _handle != nullptr;





  bool open(){

    if(isOpen){
      return true;
    }



    try {

      TerminalFFI.instance.load();



      _handle =
          TerminalFFI.instance.create(
            rows,
            cols,
          );



      return isOpen;


    }

    catch(e){

      return false;

    }

  }









  bool write(
    String text,
  ){

    if(!isOpen){
      return false;
    }



    final data =
        text.toNativeUtf8();



    try {

      final result =
          TerminalFFI.instance.write(
            _handle!,
            data,
            utf8.encode(text).length,
          );



      return result != 0;


    }

    finally {

      malloc.free(data);

    }

  }









  String read([
    int size = 8192,
  ]){


    if(!isOpen){
      return '';
    }



    final buffer =
        calloc<Uint8>(
          size,
        );



    try {


      final length =
          TerminalFFI.instance.read(
            _handle!,
            buffer,
            size,
          );



      if(length <= 0){
        return '';
      }




      return utf8.decode(
        buffer.asTypedList(
          length,
        ),
        allowMalformed:true,
      );



    }

    finally {

      calloc.free(
        buffer,
      );

    }


  }









  bool resize({

    required int cols,

    required int rows,

  }){


    if(!isOpen){
      return false;
    }



    return
        TerminalFFI.instance.resize(
          _handle!,
          rows,
          cols,
        ) != 0;


  }









  void close(){


    if(!isOpen){
      return;
    }



    TerminalFFI.instance.close(
      _handle!,
    );



    _handle = nullptr;


  }



}
