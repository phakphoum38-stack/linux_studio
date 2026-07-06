import 'package:dartssh2/dartssh2.dart';

class SshBridge {
  SSHClient? _client;
  SSHSession? _session;

  bool connected = false;

  Future<void> connect({
    required String host,
    required String username,
    required String password,
    int port = 22,
  }) async {
    final socket = await SSHSocket.connect(host, port);

    _client = SSHClient(
      socket,
      username: username,
      onPasswordRequest: () => password,
    );

    _session = await _client!.shell();

    connected = true;
  }

  void write(String data) {
    _session?.write(data);
  }

  void disconnect() {
    _session?.close();
    _client?.close();
    connected = false;
  }
}
