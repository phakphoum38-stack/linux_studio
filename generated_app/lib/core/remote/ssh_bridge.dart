/// Minimal SSH bridge stub. Replace with full SSH client integration.
class SshBridge {
  SshBridge();

  Future<void> connect(String host, int port, String user, String password) async {
    // TODO: implement SSH connection
  }

  Future<void> disconnect() async {}

  Future<void> write(String data) async {}

  Stream<String> output() async* {
    yield* Stream.empty();
  }
}
