import 'dirty_tracker.dart';
import '../engine/vt100_state_machine.dart';


class TerminalRenderController {

  final DirtyTracker dirty =
      DirtyTracker();



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
}
