import 'dart:async';

import 'screen_buffer.dart';

typedef OutputCallback = void Function(String data);

class PtyBridge {
  PtyBridge({
    ScreenBuffer? screen,
  }) : screen = screen ??
            ScreenBuffer(
              rows: 24,
              cols: 80,
            );

  final ScreenBuffer screen;

  OutputCallback? onOutput;

  bool running = false;

  final StreamController<String> _stream =
      StreamController<String>.broadcast();

  Stream<String> get output => _stream.stream;

  //--------------------------------------------------------
  // Start
  //--------------------------------------------------------

  Future<void> start([
    String? executable,
    List<String>? arguments,
  ]) async {
    running = true;

    _emit(
      'PTY started'
      '${executable == null ? "" : " : $executable"}',
    );
  }

  //--------------------------------------------------------
  // Write
  //--------------------------------------------------------

  void write(String data) {
    if (!running) return;

    screen.write(data);

    _emit(data);
  }

  //--------------------------------------------------------
  // Compatibility
  //--------------------------------------------------------

  void send(String data) {
    write(data);
  }

  void input(String data) {
    write(data);
  }

  //--------------------------------------------------------
  // ANSI helpers
  //--------------------------------------------------------

  void setForeground(int color) {
    screen.currentForeground = color;
  }

  void setBackground(int color) {
    screen.currentBackground = color;
  }

  void setColor(
    int fg,
    int bg,
    bool bold,
    bool underline,
  ) {
    screen.currentForeground = fg;
    screen.currentBackground = bg;

    screen.bold = bold;
    screen.underline = underline;
  }

  //--------------------------------------------------------
  // Stop
  //--------------------------------------------------------

  Future<void> kill() async {
    if (!running) return;

    running = false;

    _emit('PTY stopped');
  }

  Future<void> disconnect() async {
    await kill();
  }

  //--------------------------------------------------------
  // Internal
  //--------------------------------------------------------

  void _emit(String text) {
    onOutput?.call(text);

    if (!_stream.isClosed) {
      _stream.add(text);
    }
  }

  void dispose() {
    kill();

    _stream.close();
  }
}
