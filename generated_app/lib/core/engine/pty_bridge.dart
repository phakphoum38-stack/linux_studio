class PtyBridge {
  Function(String data)? onOutput;

  bool connected = false;

  Future<void> start(String host, int port) async {
    connected = true;
  }

  void write(String data, int a, int b) {
    // placeholder send
  }

  void setColor(int fg, int bg, int a, int b) {
    // placeholder
  }

  void kill() {
    connected = false;
  }
}
