import 'dart:io';
import 'dart:convert';

class TerminalSession {
  Process? process;
  Function(String data)? onOutput;

  Future<void> start() async {
    process = await Process.start('bash', [], runInShell: true);

    process!.stdout
        .transform(utf8.decoder)
        .listen((data) => onOutput?.call(data));

    process!.stderr
        .transform(utf8.decoder)
        .listen((data) => onOutput?.call(data));
  }

  void write(String input) {
    process?.stdin.writeln(input);
  }

  void kill() {
    process?.kill();
  }
}

class SessionManager {
  final List<TerminalSession> sessions = [];
  int active = 0;

  TerminalSession createSession() {
    final s = TerminalSession();
    sessions.add(s);
    return s;
  }

  TerminalSession get current => sessions[active];
}
