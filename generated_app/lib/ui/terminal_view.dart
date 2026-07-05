import 'package:flutter/material.dart';
import '../core/render/terminal_painter.dart';
import '../core/engine/screen_buffer.dart';

class TerminalView extends StatefulWidget {
  final ScreenBuffer buffer;
  final int cursorRow;
  final int cursorCol;

  const TerminalView({
    super.key,
    required this.buffer,
    required this.cursorRow,
    required this.cursorCol,
  });

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TerminalPainter(
        buffer: widget.buffer,
        cursorRow: widget.cursorRow,
        cursorCol: widget.cursorCol,
      ),
      child: Container(),
    );
  }
}
