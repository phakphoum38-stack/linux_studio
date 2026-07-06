import 'dart:async';
import 'screen_buffer.dart';

/// Release 1.0 PTY Bridge (Stub + Safe IO Layer)
///
/// หน้าที่:
/// - รับ input จาก UI
/// - ส่ง output กลับ UI
/// - เชื่อม Terminal Engine (ScreenBuffer)
class PtyBridge {
  final ScreenBuffer buffer;

  PtyBridge(this.buffer);

  /// Output stream callback (UI listens here)
  Function(String data)? onOutput;

  bool connected = false;

  final StreamController<String> _inputController =
      StreamController<String>.broadcast();

  /// Start session (mock PTY)
  void start(String host, int port) {
    connected = true;

    // simulate welcome message
    _emit("Connected to $host:$port\n");
    _emit("Release 1.0 PTY Ready\n");
  }

  /// Write command from UI → terminal
  void write(String data) {
    if (!connected) return;

    _emit("\$ $data\n");

    // basic echo simulation
    _inputController.add(data);
  }

  /// Internal output sender
  void _emit(String data) {
    if (onOutput != null) {
      onOutput!(data);
    }
  }

  /// Apply ANSI color (stub for now)
  void setColor(int fg, int bg) {
    // Release 1.0: no-op (reserved for ANSI parser)
  }

  /// Clear terminal
  void clear() {
    buffer.clear();
    _emit("\x1B[2J");
  }

  /// Kill session
  void kill() {
    connected = false;
    _inputController.close();
  }
}
