import 'dart:io';


import 'terminal_backend.dart';

import 'pty_terminal_backend.dart';

import 'ssh_terminal_backend.dart';



class BackendFactory {


 static TerminalBackend create(){


   if(
     Platform.isLinux ||
     Platform.isMacOS
   ){

     return PtyTerminalBackend();

   }



   if(
     Platform.isAndroid ||
     Platform.isIOS
   ){

     return SshTerminalBackend();

   }



   if(
     Platform.isWindows
   ){

     return PtyTerminalBackend();

   }



   throw UnsupportedError(
     "Platform not supported",
   );

 }


}
