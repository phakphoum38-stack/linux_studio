import 'dart:ui';
import '../engine/screen_buffer.dart';

class TerminalPainter extends CustomPainter {
  final ScreenBuffer buffer;
  final int cursorRow;
  final int cursorCol;

  TerminalPainter({
    required this.buffer,
    required this.cursorRow,
    required this.cursorCol,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Reuse a single TextPainter to reduce allocations
    final textStyle = const TextStyle(
      color: Color(0xFF00FF00),
      fontSize: 14,
      fontFamily: 'monospace',
    );

    final tp = TextPainter(textDirection: TextDirection.ltr);

    // Measure a representative glyph once to determine cell size
    tp.text = const TextSpan(text: 'W', style: TextStyle(fontSize: 14, fontFamily: 'monospace'));
    tp.layout();
    final double cellWidth = tp.width;
    final double cellHeight = tp.height;

    // Clip to prevent painting outside bounds
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    for (int r = 0; r < buffer.height; r++) {
      final double y = r * cellHeight;
      for (int c = 0; c < buffer.width; c++) {
        final cell = buffer.buffer[r][c];
        final ch = cell.char;

        // Skip empty spaces to reduce painting work
        if (ch.isEmpty || ch == ' ') continue;

        tp.text = TextSpan(text: ch, style: textStyle);
        tp.layout();
        tp.paint(canvas, Offset(c * cellWidth, y));
      }
    }

    canvas.restore();

    final cursorPaint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;

    final cursorRect = Rect.fromLTWH(
      cursorCol * cellWidth,
      cursorRow * cellHeight,
      cellWidth * 0.8,
      cellHeight * 0.9,
    );

    canvas.drawRect(cursorRect, cursorPaint);
  }

  @override
  bool shouldRepaint(covariant TerminalPainter oldDelegate) {
    // Repaint when the buffer instance changed (content likely changed),
    // when buffer dimensions change, or when cursor position changes.
    if (!identical(buffer, oldDelegate.buffer)) return true;
    if (buffer.width != oldDelegate.buffer.width || buffer.height != oldDelegate.buffer.height) return true;
    if (cursorRow != oldDelegate.cursorRow || cursorCol != oldDelegate.cursorCol) return true;
    return false;
  }
}
