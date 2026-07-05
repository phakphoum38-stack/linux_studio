import 'dart:convert';
import 'dart:io';

import 'ansi_parser.dart';
import 'screen_buffer.dart';

class TerminalEngine {
  Process? _process;

  final buffer = ScreenBuffer(40, 120);

  Function()? onUpdate;

  Future<void> start(Function() callback) async {
    onUpdate = callback;

    _process = await Process.start(
      'bash',
      [],
      runInShell: true,
    );

    _process!.stdout
        .transform(utf8.decoder)
        .listen(_handle);

    _process!.stderr
        .transform(utf8.decoder)
        .listen(_handle);
  }

  void _handle(String data) {
    final tokens = AnsiParser.parse(data);

    buffer.writeTokens(tokens);

    onUpdate?.call();
  }

  void write(String cmd) {
    _process?.stdin.writeln(cmd);
  }

  void dispose() {
    _process?.kill();
  }
}
