/// Minimal PTY bridge stub. Replace with real native integration when available.
class PtyBridge {
  PtyBridge();

  /// Start the backend PTY process. In stub mode this does nothing.
  Future<void> start() async {
    // TODO: implement platform-specific PTY spawning
  }

  /// Write bytes to the PTY stdin.
  Future<void> write(String data) async {
    // TODO: implement
  }

  /// Stream of output from the PTY.
  Stream<String> output() async* {
    // TODO: return real PTY output
    yield* Stream.empty();
  }

  void dispose() {
    // cleanup
  }
}
