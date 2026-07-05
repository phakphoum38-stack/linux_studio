import 'session_manager.dart';
import 'streaming_terminal_engine.dart';

class SessionBinding {
  final StreamingTerminalEngine engine;

  SessionBinding(this.engine);

  void bind(TerminalSession session) {
    session.onOutput = (data) {
      engine.feed(data);
    };
  }
}
