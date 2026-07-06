import 'dart:async';

typedef SshOutputCallback = void Function(String data);

class SshBridge {
  bool connected = false;

  String? host;
  int port = 22;
  String? username;

  SshOutputCallback? onOutput;

  final StreamController<String> _stream =
      StreamController<String>.broadcast();

  Stream<String> get output => _stream.stream;

  //----------------------------------------------------------
  // Connect
  //----------------------------------------------------------

  Future<bool> connect({
    required String host,
    int port = 22,
    required String username,
    String? password,
  }) async {
    this.host = host;
    this.port = port;
    this.username = username;

    connected = true;

    _emit(
      'Connected to $host:$port as $username',
    );

    return true;
  }

  //----------------------------------------------------------
  // Compatibility API
  //----------------------------------------------------------

  Future<void> open({
    required String host,
    required String username,
    String? password,
    int port = 22,
  }) async {
    await connect(
      host: host,
      username: username,
      password: password,
      port: port,
    );
  }

  //----------------------------------------------------------
  // Write
  //----------------------------------------------------------

  void write(String data) {
    if (!connected) return;

    _emit(data);
  }

  void send(String data) {
    write(data);
  }

  //----------------------------------------------------------
  // Disconnect
  //----------------------------------------------------------

  Future<void> disconnect() async {
    if (!connected) return;

    connected = false;

    _emit('Disconnected');
  }

  void close() {
    disconnect();
  }

  //----------------------------------------------------------
  // Internal
  //----------------------------------------------------------

  void _emit(String text) {
    onOutput?.call(text);

    if (!_stream.isClosed) {
      _stream.add(text);
    }
  }

  void dispose() {
    disconnect();
    _stream.close();
  }
}
