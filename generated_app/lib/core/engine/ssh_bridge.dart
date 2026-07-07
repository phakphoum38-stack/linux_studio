import 'dart:async';
import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';

class SshBridge {
  SSHClient? _client;
  SSHSession? _session;

  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;

  final StreamController<String> _outputController =
      StreamController<String>.broadcast();

  bool connected = false;

  Function(String)? onOutput;
  Function(String)? onError;

  Stream<String> get outputStream => _outputController.stream;

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
        pty: const SSHPtyConfig(
          width: 80,
          height: 24,
        ),
      );

      connected = true;

      _listenOutput();
    } catch (e) {
      connected = false;
      onError?.call(e.toString());
      rethrow;
    }
  }

  void _listenOutput() {
    if (_session == null) return;

    _stdoutSub = _session!.stdout
        .cast<List<int>>()
        .transform(utf8.decoder)
        .listen((text) {
      _outputController.add(text);
      onOutput?.call(text);
    });

    _stderrSub = _session!.stderr
        .cast<List<int>>()
        .transform(utf8.decoder)
        .listen((text) {
      _outputController.add(text);
      onOutput?.call(text);
    });
  }

  void write(String text) {
    if (!connected || _session == null) return;

    _session!.write(text);
  }

  void resize(int cols, int rows) {
    if (!connected || _session == null) return;

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

    await _session?.close();

    _client?.close();

    _session = null;
    _client = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _outputController.close();
  }
}
