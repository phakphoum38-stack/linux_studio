import 'streaming_terminal_engine.dart';
import 'dart:io';
import 'dart:convert';

class PtyStreamBridge {
  final StreamingTerminalEngine engine = StreamingTerminalEngine();
  Process? _process;

  Function(String text, int row, int col)? onOutput;

  Future<void> start() async {
    _process = await Process.start('bash', [], runInShell: true);

    _process!.stdout
        .transform(utf8.decoder)
        .listen((data) => engine.feed(data));

    engine.onText = (text, row, col) {
      onOutput?.call(text, row, col);
    };
  }

  void write(String input) {
    _process?.stdin.writeln(input);
  }

  void kill() {
    _process?.kill();
  }
}
