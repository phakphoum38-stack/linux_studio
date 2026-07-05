import 'dart:io';

class SshSession {
  Process? _process;

  Function(String data)? onOutput;

  Future<void> connect(String host, String user) async {
    _process = await Process.start(
      'ssh',
      ['$user@$host'],
      runInShell: true,
    );

    _process!.stdout.listen((data) {
      onOutput?.call(String.fromCharCodes(data));
    });

    _process!.stderr.listen((data) {
      onOutput?.call(String.fromCharCodes(data));
    });
  }

  void write(String input) {
    _process?.stdin.writeln(input);
  }

  void close() {
    _process?.kill();
  }
}
