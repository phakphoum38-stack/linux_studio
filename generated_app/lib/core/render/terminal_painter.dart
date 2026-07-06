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

  // Static glyph cache shared across painter instances to avoid repeated layouts
  static final Map<String, TextPainter> _glyphCache = {};

  @override
  void paint(Canvas canvas, Size size) {
    // Reuse a single TextPainter for measuring
    const textStyle = TextStyle(
      color: Color(0xFF00FF00),
      fontSize: 14,
      fontFamily: 'monospace',
    );

    final measureTp = TextPainter(textDirection: TextDirection.ltr);
    measureTp.text = const TextSpan(text: 'W', style: TextStyle(fontSize: 14, fontFamily: 'monospace'));
    measureTp.layout();
    final double cellWidth = measureTp.width;
    final double cellHeight = measureTp.height;

    // Clip to prevent painting outside bounds
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    for (int r = 0; r < buffer.height; r++) {
      final double y = r * cellHeight;
      for (int c = 0; c < buffer.width; c++) {
        final cell = buffer.buffer[r][c];
        final ch = cell.char;

        // Skip empty spaces
        if (ch.isEmpty || ch == ' ') continue;

        // Use glyph cache keyed by the character and style (simplified: only char key)
        var glyphTp = _glyphCache[ch];
        if (glyphTp == null) {
          glyphTp = TextPainter(
            text: TextSpan(text: ch, style: textStyle),
            textDirection: TextDirection.ltr,
          );
          glyphTp.layout();
          _glyphCache[ch] = glyphTp;
        }

        glyphTp.paint(canvas, Offset(c * cellWidth, y));
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
    if (!identical(buffer, oldDelegate.buffer)) return true;
    if (buffer.width != oldDelegate.buffer.width || buffer.height != oldDelegate.buffer.height) return true;
    if (cursorRow != oldDelegate.cursorRow || cursorCol != oldDelegate.cursorCol) return true;
    return false;
  }
}
