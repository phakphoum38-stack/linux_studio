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
    const textStyle = TextStyle(
      color: Color(0xFF00FF00),
      fontSize: 14,
      fontFamily: 'monospace',
    );

    for (int r = 0; r < buffer.height; r++) {
      for (int c = 0; c < buffer.width; c++) {
        final cell = buffer.buffer[r][c];

        final tp = TextPainter(
          text: TextSpan(
            text: cell.char,
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
        );

        tp.layout();
        tp.paint(
          canvas,
          Offset(c * 10.0, r * 16.0),
        );
      }
    }

    final cursorPaint = Paint()
      ..color = const Color(0xFF00FF00)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        cursorCol * 10.0,
        cursorRow * 16.0,
        8,
        14,
      ),
      cursorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant TerminalPainter oldDelegate) {
    return true;
  }
}
