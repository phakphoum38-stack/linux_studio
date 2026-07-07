import 'screen_buffer.dart';
import 'ssh_bridge.dart';



typedef VoidCallback = void Function();



class PtyBridge {


  final ScreenBuffer buffer;


  final SshBridge ssh;



  VoidCallback? onRefresh;



  bool running = false;




  PtyBridge({

    required this.buffer,

    required this.ssh,

  });





  void start() {


    running = true;



    ssh.onOutput =
        (data) {


      buffer.writeText(
        data,
      );


      onRefresh?.call();

    };



    ssh.onError =
        (error) {


      buffer.writeText(
        "\nERROR: $error\n",
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


      // local terminal fallback

      buffer.writeText(
        "$text\n",
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
