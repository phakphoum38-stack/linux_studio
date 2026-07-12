import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'terminal_backend.dart';

/// Command-backed runtime for containers, QEMU, and headless servers.
class ProcessTerminalBackend implements TerminalBackend {
  final String executable;
  final List<String> arguments;
  final Map<String, String> environment;
  final String? workingDirectory;
  final _output = StreamController<String>.broadcast();
  final _errors = StreamController<String>.broadcast();
  Process? _process;

  ProcessTerminalBackend({
    required this.executable,
    this.arguments = const [],
    this.environment = const {},
    this.workingDirectory,
  });

  @override
  Stream<String> get output => _output.stream;
  @override
  Stream<String> get errors => _errors.stream;

  @override
  Future<void> start() async {
    if (_process != null) return;
    try {
      final process = await Process.start(
        executable,
        arguments,
        environment: environment.isEmpty ? null : environment,
        workingDirectory: workingDirectory,
        runInShell: Platform.isWindows,
      );
      _process = process;
      process.stdout.transform(utf8.decoder).listen(_output.add);
      process.stderr.transform(utf8.decoder).listen(_errors.add);
      unawaited(process.exitCode.then((code) {
        if (code != 0) _errors.add('$executable exited with code $code');
        _process = null;
      }));
    } catch (error) {
      _errors.add(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> write(String text) async => _process?.stdin.write(text);
  @override
  String read() => '';
  @override
  Future<void> resize(int cols, int rows) async {}

  @override
  Future<void> stop() async {
    final process = _process;
    _process = null;
    if (process == null) return;
    await process.stdin.close();
    process.kill();
  }
}
