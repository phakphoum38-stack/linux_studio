import 'ansi_csi_parser.dart';
import 'screen_buffer.dart';
import 'vt100_state_machine.dart';

class VT100Controller {
  final VT100StateMachine _machine;

  VT100Controller({
    ScreenBuffer? buffer,
  }) : _machine = VT100StateMachine(buffer);

  void handle(
    AnsiEvent event,
    ScreenBuffer target,
  ) {
    _machine.handle(event);
  }

  void execute(
    String command,
    List<int> args,
    ScreenBuffer target,
  ) {
    _machine.process(
      command,
      args,
      target,
    );
  }
}
