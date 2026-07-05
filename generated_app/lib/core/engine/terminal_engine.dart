import 'dart:io';
import 'dart:convert';
import 'ansi_csi_parser.dart';

class TerminalEngine {
  Process? _process;

  final AnsiCsiParser parser = AnsiCsiParser();

  Function(dynamic event)? onEvent;

  Future<void> start(Function(dynamic event) callback) async {
    onEvent = callback;

    _process = await Process.start(
      'bash',
      [],
      runInShell: true,
    );

    _process!.stdout.transform(utf8.decoder).listen((data) {
      final events = parser.parse(data);

      for (final e in events) {
        onEvent?.call(e);
      }
    });

    _process!.stderr.transform(utf8.decoder).listen((data) {
      final events = parser.parse(data);

      for (final e in events) {
        onEvent?.call(e);
      }
    });
  }

  void write(String input) {
    _process?.stdin.writeln(input);
  }

  void kill() {
    _process?.kill();
  }
}
