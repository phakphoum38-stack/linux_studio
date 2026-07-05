import 'dart:convert';
import 'dart:io';

class TerminalEngine {
  Process? _process;

  Function(String data)? onData;

  bool get isRunning => _process != null;

  /// start bash session
  Future<void> start(Function(String data) callback) async {
    onData = callback;

    _process = await Process.start(
      'bash',
      [],
      runInShell: true,
    );

    _process!.stdout
        .transform(utf8.decoder)
        .listen((data) {
      onData?.call(_clean(data));
    });

    _process!.stderr
        .transform(utf8.decoder)
        .listen((data) {
      onData?.call(_clean(data));
    });
  }

  /// send command
  void write(String input) {
    if (_process == null) return;

    _process!.stdin.writeln(input);
  }

  /// raw input (future PTY upgrade)
  void writeRaw(String input) {
    _process?.stdin.write(input);
  }

  /// kill shell
  void dispose() {
    _process?.kill();
    _process = null;
  }

  /// basic ANSI cleaner
  String _clean(String input) {
    return input
        .replaceAll('\u001B', '')
        .replaceAll(RegExp(r'\[[0-9;]*m'), '');
  }
}
