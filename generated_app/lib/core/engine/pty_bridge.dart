import 'screen_buffer.dart';
import 'ssh_bridge.dart';
import 'ansi_parser.dart';
import 'vt100_state_machine.dart';


typedef VoidCallback = void Function();



class PtyBridge {


  final ScreenBuffer buffer;


  final SshBridge ssh;



  final VT100StateMachine vt100 =
      VT100StateMachine();



  late final AnsiParser parser;



  VoidCallback? onRefresh;



  bool running = false;




  PtyBridge({

    required this.buffer,

    required this.ssh,

  }) {

    parser = AnsiParser(
      vt100,
    );

  }





  void start() {


    running = true;



    ssh.onOutput =
        (data) {


      if (!running) {
        return;
      }



      // ANSI Output
      // SSH -> Parser -> ScreenBuffer

      parser.parse(
        data,
        buffer,
      );



      onRefresh?.call();

    };





    ssh.onError =
        (error) {


      parser.parse(
        "\nERROR: $error\n",
        buffer,
      );



      onRefresh?.call();

    };
  }








  void write(
    String text,
  ) {


    if (!running) {
      return;
    }



    if (ssh.connected) {


      ssh.write(
        "$text\n",
      );


    } else {


      // Local mode

      parser.parse(
        "$text\n",
        buffer,
      );


      onRefresh?.call();

    }

  }








  Future<void> connect({

    required String host,

    required String username,

    required String password,

    int port = 22,

  }) {


    return ssh.connect(

      host: host,

      username: username,

      password: password,

      port: port,

    );

  }








  void resize(

    int cols,

    int rows,

  ) {


    ssh.resize(
      cols,
      rows,
    );

  }








  Future<void> kill() async {


    running = false;


    await ssh.disconnect();

  }

}
