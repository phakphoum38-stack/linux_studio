import 'dart:io';

import 'terminal_backend.dart';

import 'windows_terminal_backend.dart';

import 'pty_terminal_backend.dart';





class BackendFactory {



  static TerminalBackend create()

  {



    if(Platform.isWindows)

    {

      return WindowsTerminalBackend();

    }







    if(Platform.isLinux ||

       Platform.isMacOS)

    {

      return PtyTerminalBackend();

    }







    throw UnsupportedError(

      'Unsupported platform',

    );


  }



}