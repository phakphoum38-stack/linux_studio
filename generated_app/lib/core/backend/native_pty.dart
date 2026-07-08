import 'dart:ffi';
import 'dart:io';



class NativePty {


  late DynamicLibrary lib;



  NativePty(){

    if(
      Platform.isLinux
    ){

      lib =
        DynamicLibrary.open(
          "libpty.so",
        );

    }

  }





  late final spawn =
      lib.lookupFunction<
        Int32 Function(
          Pointer<Void>,
          Int32,
          Int32,
        ),
        int Function(
          Pointer<Void>,
          int,
          int,
        )
      >(
        "pty_spawn",
      );

}
