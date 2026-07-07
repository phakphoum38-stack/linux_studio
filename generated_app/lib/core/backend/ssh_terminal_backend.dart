import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';

import 'terminal_backend.dart';



class SshTerminalBackend
    implements TerminalBackend {



 SSHClient? client;

 SSHSession? session;



 @override
 Function(String data)? onOutput;



 @override
 Function(String error)? onError;






 Future<void> connect({

 required String host,

 required String username,

 required String password,

 int port=22,

 }) async {


 final socket =
   await SSHSocket.connect(
     host,
     port,
   );



 client =
   SSHClient(
     socket,

     username:
       username,


     onPasswordRequest:
       ()=>password,

   );



 session =
   await client!.shell(
     pty:
       SSHPtyConfig(
         width:80,
         height:24,
       ),
   );




 session!
   .stdout
   .transform(
     utf8.decoder,
   )
   .listen((data){

     onOutput?.call(
       data,
     );

   });



 }







 @override
 Future<void> start()
 async {

 }



 @override
 void write(
   String data,
 ){

   session?.write(
     data,
   );

 }






 @override
 void resize(
   int cols,
   int rows,
 ){

   session?.resizeTerminal(
     cols,
     rows,
     0,
     0,
   );

 }






 @override
 Future<void> stop()
 async {

   await session?.close();

   client?.close();

 }


}
