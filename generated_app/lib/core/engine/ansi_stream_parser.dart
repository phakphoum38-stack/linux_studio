import '../engine/vt100_state_machine.dart';
import '../render/terminal_controller_v5.dart';

/// Minimal ANSI stream parser that supports basic printing and a small
/// subset of CSI sequences required by the app:
/// - ESC [ <r> ; <c> H  (cursor position)
/// - ESC [ <n> A/B/C/D   (cursor up/down/right/left)
/// - ESC [ 2 J  (clear screen)
class AnsiStreamParser {
  final VT100StateMachine vt100;
  final TerminalControllerV5 controller;

  AnsiStreamParser(this.vt100, this.controller);

  void feed(String input) {
    int i = 0;
    while (i < input.length) {
      final ch = input[i];
      if (ch == '\x1b') {
        // Escape sequence
        if (i + 1 < input.length && input[i + 1] == '[') {
          i += 2;
          final sb = StringBuffer();
          while (i < input.length) {
            final c = input[i];
            sb.write(c);
            i++;
            // CSI sequences end with a letter in the range @-~
            if (RegExp(r'[\x40-\x7E]').hasMatch(c)) break;
          }
          final seq = sb.toString();
          _handleCsi(seq);
          continue;
        } else {
          // unsupported escape: skip
          i++;
          continue;
        }
      }

      // Printable character: write to buffer at vt100 cursor
      controller.putString(vt100.cursorRow, vt100.cursorCol, ch);
      vt100.cursorCol += 1;
      i++;
    }
  }

  void _handleCsi(String seq) {
    // seq example: "12;40H" or "2J" or "A" etc.
    final match = RegExp(r'(?:(\d*;?)*)([A-Za-z])').firstMatch(seq);
    if (match == null) return;
    final params = seq.substring(0, seq.length - 1);
    final cmd = seq[seq.length - 1];

    final args = <int>[];
    if (params.isNotEmpty) {
      for (final part in params.split(';')) {
        if (part.isEmpty) continue;
        final val = int.tryParse(part) ?? 0;
        args.add(val);
      }
    }

    // Apply via vt100 state machine
    vt100.applyCommand(cmd, args);

    // Handle some commands at higher level
    if (cmd == 'J') {
      if (args.isNotEmpty && args[0] == 2) {
        // Clear entire screen
        controller.clearScreen();
      }
    }
  }
}
