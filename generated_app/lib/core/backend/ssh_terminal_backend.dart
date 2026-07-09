import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';

import 'terminal_backend.dart';

class SshTerminalBackend implements TerminalBackend {
  SSHClient? _client;
  SSHSession? _session;

  final StreamController<String> _outputController =
      StreamController<String>.broadcast();

  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get output =>
      _outputController.stream;

  @override
  Stream<String> get errors =>
      _errorController.stream;

  Future<void> connect({
    required String host,
    required String username,
    required String password,
    int port = 22,
  }) async {
    try {
      final socket = await SSHSocket.connect(
        host,
        port,
      );

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

      _session!.stdout.listen(
        (data) {
          _outputController.add(
            utf8.decode(data),
          );
        },
        onError: (e) {
          _errorController.add(
            e.toString(),
          );
        },
      );
    } catch (e) {
      _errorController.add(
        e.toString(),
      );
      rethrow;
    }
  }

  @override
  Future<void> start() async {
    // connect() จะเป็นผู้สร้าง session
  }

  @override
  Future<void> write(String text) async {
    _session?.write(
      Uint8List.fromList(
        utf8.encode(text),
      ),
    );
  }

  @override
  String read() {
    return '';
  }

  @override
  Future<void> resize(
    int cols,
    int rows,
  ) async {
    _session?.resizeTerminal(
      cols,
      rows,
      0,
      0,
    );
  }

  @override
  Future<void> stop() async {
    _session?.close(); // ไม่ต้อง await

    _client?.close();

    await _outputController.close();
    await _errorController.close();
  }
}
