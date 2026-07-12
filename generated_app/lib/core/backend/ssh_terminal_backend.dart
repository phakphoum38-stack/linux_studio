import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';

import 'terminal_backend.dart';

class SshTerminalBackend implements TerminalBackend {
  final String? _configuredHost;
  final int _configuredPort;
  final String? _configuredUsername;
  final String? _configuredPassword;
  SSHClient? _client;
  SSHSession? _session;
  final _outputController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  SshTerminalBackend()
      : _configuredHost = null,
        _configuredPort = 22,
        _configuredUsername = null,
        _configuredPassword = null;

  SshTerminalBackend.configured({
    required String host,
    required String username,
    required String password,
    int port = 22,
  })  : _configuredHost = host,
        _configuredPort = port,
        _configuredUsername = username,
        _configuredPassword = password;

  @override
  Stream<String> get output => _outputController.stream;
  @override
  Stream<String> get errors => _errorController.stream;

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
        pty: const SSHPtyConfig(width: 80, height: 24),
      );
      _session!.stdout.listen(
        (data) => _outputController.add(utf8.decode(data)),
        onError: (Object error) => _errorController.add(error.toString()),
      );
      _session!.stderr.listen(
        (data) => _errorController.add(utf8.decode(data)),
      );
    } catch (error) {
      _errorController.add(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> start() async {
    if (_session != null) return;
    final host = _configuredHost;
    final username = _configuredUsername;
    final password = _configuredPassword;
    if (host == null || username == null || password == null) {
      throw StateError('SSH connection details were not configured');
    }
    await connect(
      host: host,
      port: _configuredPort,
      username: username,
      password: password,
    );
  }

  @override
  Future<void> write(String text) async {
    _session?.write(Uint8List.fromList(utf8.encode(text)));
  }

  @override
  String read() => '';

  @override
  Future<void> resize(int cols, int rows) async {
    _session?.resizeTerminal(cols, rows, 0, 0);
  }

  @override
  Future<void> stop() async {
    _session?.close();
    _session = null;
    _client?.close();
    _client = null;
  }

  Future<void> dispose() async {
    await stop();
    await _outputController.close();
    await _errorController.close();
  }
}
