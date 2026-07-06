import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';

class SshBridge {
  SSHClient? _client;
  SSHSession? _session;

  bool connected = false;

  StreamSubscription<List<int>>? _stdoutSub;
  StreamSubscription<List<int>>? _stderrSub;

  /// Output stream callback (ส่งเข้า terminal)
  Function(String data)? onOutput;

  /// Error callback
  Function(String error)? onError;

  /// Connect to SSH server and open interactive shell
  Future<void> connect({
    required String host,
    required String username,
    required String password,
    int port = 22,
  }) async {
    try {
      final socket = await SSHSocket.connect(host, port);

      _client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );

      _session = await _client!.shell(
        pty: SSHPtyConfig(
          width: 80,
          height: 24,
        ),
      );

      connected = true;

      // stdout stream
      _stdoutSub = _session!.stdout.listen((data) {
        onOutput?.call(utf8.decode(data));
      });

      // stderr stream
      _stderrSub = _session!.stderr.listen((data) {
        onOutput?.call(utf8.decode(data));
      });
    } catch (e) {
      connected = false;
      onError?.call(e.toString());
      rethrow;
    }
  }

  /// Send command to remote shell
  void write(String data) {
    if (!connected || _session == null) return;

    _session!.write(utf8.encode(data + '\n'));
  }

  /// Resize terminal (important for full terminal support)
  void resize(int cols, int rows) {
    _session?.resizeTerminal(cols, rows, rows);
  }

  /// Disconnect safely
  Future<void> disconnect() async {
    try {
      await _stdoutSub?.cancel();
      await _stderrSub?.cancel();

      await _session?.close();
      await _client?.close();

      _session = null;
      _client = null;

      connected = false;
    } catch (e) {
      onError?.call(e.toString());
    }
  }
}
