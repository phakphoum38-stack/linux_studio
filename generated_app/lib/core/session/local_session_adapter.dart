import 'session_interface.dart';
import '../engine/session_manager.dart';

class LocalSessionAdapter implements TerminalSessionInterface {
  final TerminalSession session;

  Function(String data)? _handler;

  LocalSessionAdapter(this.session) {
    session.onOutput = (data) {
      _handler?.call(data);
    };
  }

  @override
  void setOutputHandler(Function(String data) handler) {
    _handler = handler;
  }

  @override
  void write(String input) {
    session.write(input);
  }

  @override
  void close() {
    session.kill();
  }
}
