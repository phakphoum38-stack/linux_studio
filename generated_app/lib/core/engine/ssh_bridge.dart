import 'dart:async';
import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';


class SshBridge {

  SSHClient? _client;

  SSHSession? _session;


  bool connected = false;


  StreamSubscription? _stdoutSub;

  StreamSubscription? _stderrSub;



  Function(String data)? onOutput;

  Function(String error)? onError;



  Future<void> connect({

    required String host,

    required String username,

    required String password,

    int port = 22,

  }) async {


    try {


      final socket =
          await SSHSocket.connect(
            host,
            port,
          );



      _client =
          SSHClient(

            socket,

            username: username,

            onPasswordRequest:
                () => password,
          );



      _session =
          await _client!.shell(
            pty:
                SSHPtyConfig(
                  width: 80,
                  height: 24,
                ),
          );



      connected = true;



      _stdoutSub =
          _session!.stdout.listen(
            (data) {

          onOutput?.call(
            utf8.decode(data),
          );

        });



      _stderrSub =
          _session!.stderr.listen(
            (data) {

          onOutput?.call(
            utf8.decode(data),
          );

        });



    } catch(e) {


      connected = false;


      onError?.call(
        e.toString(),
      );


      rethrow;
    }
  }




  void write(
    String text,
  ) {


    if (!connected ||
        _session == null) {

      return;
    }



    _session!.write(
      utf8.encode(
        text,
      ),
    );
  }





  void resize(
    int cols,
    int rows,
  ) {


    if (!connected ||
        _session == null) {

      return;
    }



    _session!.resizeTerminal(
      cols,
      rows,
      0,
      0,
    );
  }





  Future<void> disconnect() async {


    connected = false;



    await _stdoutSub?.cancel();

    await _stderrSub?.cancel();



    _session?.close();



    _client?.close();



    _session = null;

    _client = null;
  }
}
