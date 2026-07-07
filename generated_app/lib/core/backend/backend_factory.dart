import 'dart:io';

import 'terminal_backend.dart';

import 'native_pty_backend.dart';
import 'ssh_terminal_backend.dart';



enum TerminalMode {

  local,

  ssh,

}





class BackendFactory {



  static TerminalBackend create({

    TerminalMode mode =
        TerminalMode.local,

  }) {


    switch(mode){


      case TerminalMode.local:

        return _createLocal();



      case TerminalMode.ssh:

        return SshTerminalBackend();


    }

  }









  static TerminalBackend _createLocal(){



    if(
      Platform.isLinux ||
      Platform.isMacOS
    ){

      return NativePtyBackend();

    }






    if(
      Platform.isWindows
    ){

      //
      // Phase 16.9
      // Windows ConPTY
      //

      return NativePtyBackend();

    }






    throw UnsupportedError(

      "Local terminal is not supported on this platform"

    );


  }









  static TerminalBackend createSSH(){


    return SshTerminalBackend();


  }





}
