import 'package:flutter/material.dart';
import '../core/engine/screen_buffer.dart';

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

    widget.buffer.cursor.startBlink(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.buffer.cursor.stopBlink();
    super.dispose();
  }

  Color _color(int code) {
    switch (code) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.blue;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.buffer;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(b.rows, (r) {
          return Row(
            children: List.generate(b.cols, (c) {
              final cell = b.buffer[r][c];

              final isCursor =
                  b.cursor.visible &&
                  b.cursor.row == r &&
                  b.cursor.col == c;

              return Container(
                width: 10,
                height: 18,
                color: isCursor
                    ? Colors.white
                    : Colors.transparent,
                child: Text(
                  cell.char,
                  style: TextStyle(
                    color: _color(cell.fg),
                    fontFamily: 'monospace',
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
