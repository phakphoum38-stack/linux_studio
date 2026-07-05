import '../engine/vt100_state_machine.dart';
import 'dirty_tracker.dart';

class TerminalRenderController {
  final DirtyTracker dirty = DirtyTracker();

  void applyVT100(
    String cmd,
    List<int> args,
    VT100StateMachine vt100,
  ) {
    vt100.applyCommand(cmd, args);

    dirty.mark(vt100.cursorRow, vt100.cursorCol);
  }
}
