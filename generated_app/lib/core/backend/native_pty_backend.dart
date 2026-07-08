import 'native_pty.dart';
import 'terminal_backend.dart';

class NativePtyBackend
    implements TerminalBackend {


@override
Function(String)? onOutput;


@override
Function(String)? onError;



final NativePty pty =
    NativePty();



@override
Future<void> start()
async {


 // forkpty()

}



@override
void write(
 String data
){

 // pty_write()

}



@override
void resize(
 int cols,
 int rows
){

 // ioctl()

}



@override
Future<void> stop()
async {


 // kill child


}


}
