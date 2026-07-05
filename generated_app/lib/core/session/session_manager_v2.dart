import '../remote/ssh_session.dart';
import '../engine/session_manager.dart';

class SessionManagerV2 {
  final List<dynamic> sessions = [];
  int activeIndex = 0;

  void addLocal(TerminalSession session) {
    sessions.add(session);
  }

  void addRemote(SshSession session) {
    sessions.add(session);
  }

  dynamic get active => sessions[activeIndex];

  void switchTo(int index) {
    activeIndex = index.clamp(0, sessions.length - 1);
  }
}
