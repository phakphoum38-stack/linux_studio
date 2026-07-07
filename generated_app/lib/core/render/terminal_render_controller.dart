import '../engine/vt100_state_machine.dart';
import 'dirty_tracker.dart';

class TerminalRenderController {
  final DirtyTracker dirty;

  TerminalRenderController({
    DirtyTracker? tracker,
  }) : dirty = tracker ?? DirtyTracker();

  /// Apply VT100 command
  void applyVT100(
    String command,
    List<int> args,
    VT100StateMachine vt100,
  ) {
    vt100.applyCommand(
      command,
      args,
    );

    dirty.mark(
      vt100.cursorRow,
      vt100.cursorCol,
    );
  }

  /// Mark full screen update
  void invalidateAll({
    int rows = 24,
    int cols = 80,
  }) {
    dirty.markAll(
      rows: rows,
      cols: cols,
    );
  }

  /// Clear dirty state
  void clear() {
    dirty.clear();
  }
}
