import 'package:flutter/material.dart';

import 'screen_buffer.dart';

class TerminalView extends StatefulWidget {
  final ScreenBuffer buffer;

  const TerminalView({
    super.key,
    required this.buffer,
  });

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  @override
  void initState() {
    super.initState();

    // Optional cursor blinking.
    try {
      widget.buffer.cursor.startBlink(() {
        if (mounted) {
          setState(() {});
        }
      });
    } catch (_) {
      // Cursor blinking not implemented.
    }
  }

  @override
  void dispose() {
    try {
      widget.buffer.cursor.stopBlink();
    } catch (_) {}

    super.dispose();
  }

  Color _ansiColor(int code) {
    switch (code) {
      case 30:
        return Colors.black;
      case 31:
        return Colors.red;
      case 32:
        return Colors.green;
      case 33:
        return Colors.yellow;
      case 34:
        return Colors.blue;
      case 35:
        return Colors.purple;
      case 36:
        return Colors.cyan;
      case 37:
      default:
        return Colors.white;
    }
  }

  Color _ansiBackground(int code) {
    switch (code) {
      case 40:
        return Colors.black;
      case 41:
        return Colors.red;
      case 42:
        return Colors.green;
      case 43:
        return Colors.yellow;
      case 44:
        return Colors.blue;
      case 45:
        return Colors.purple;
      case 46:
        return Colors.cyan;
      case 47:
        return Colors.white;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = widget.buffer;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          screen.rows,
          (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                screen.cols,
                (col) {
                  final cell = screen.buffer[row][col];

                  bool cursorVisible = false;

                  try {
                    cursorVisible =
                        screen.cursor.visible &&
                        screen.cursor.row == row &&
                        screen.cursor.col == col;
                  } catch (_) {}

                  return Container(
                    width: 10,
                    height: 18,
                    alignment: Alignment.center,
                    color: cursorVisible
                        ? Colors.white
                        : _ansiBackground(cell.background),
                    child: Text(
                      cell.char,
                      style: TextStyle(
                        color: cursorVisible
                            ? Colors.black
                            : _ansiColor(cell.foreground),
                        fontFamily: 'monospace',
                        fontWeight: cell.bold
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontStyle: cell.italic
                            ? FontStyle.italic
                            : FontStyle.normal,
                        decoration: cell.underline
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        fontSize: 14,
                        height: 1.0,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
