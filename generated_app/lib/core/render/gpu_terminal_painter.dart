import 'dart:ui';
import '../../engine/screen_buffer.dart';

class GpuTerminalPainter extends CustomPainter {
  final ScreenBuffer buffer;

  GpuTerminalPainter(this.buffer);

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = const TextStyle(
      color: Color(0xFF00FF00),
      fontSize: 14,
      fontFamily: 'monospace',
    );

    final tp = TextPainter(textDirection: TextDirection.ltr);

    // Measure a glyph to compute cell size
    tp.text = const TextSpan(text: 'W', style: TextStyle(fontSize: 14, fontFamily: 'monospace'));
    tp.layout();
    final double cellWidth = tp.width;
    final double cellHeight = tp.height;

    canvas.save();
    canvas.clipRect(Offset.zero & size);

    for (int r = 0; r < buffer.height; r++) {
      final double y = r * cellHeight;
      for (int c = 0; c < buffer.width; c++) {
        final ch = buffer.buffer[r][c].char;
        if (ch.isEmpty || ch == ' ') continue;

        tp.text = TextSpan(text: ch, style: textStyle);
        tp.layout();
        tp.paint(canvas, Offset(c * cellWidth, y));
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GpuTerminalPainter oldDelegate) {
    if (buffer.width != oldDelegate.buffer.width || buffer.height != oldDelegate.buffer.height) return true;
    if (!identical(buffer, oldDelegate.buffer)) return true;
    return false;
  }
}
