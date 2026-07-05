import 'dart:ui';

class GpuTerminalPainter extends CustomPainter {
  final List<List<String>> buffer;

  GpuTerminalPainter(this.buffer);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final textStyle = const TextStyle(
      color: Color(0xFF00FF00),
      fontSize: 14,
      fontFamily: 'monospace',
    );

    for (int r = 0; r < buffer.length; r++) {
      for (int c = 0; c < buffer[r].length; c++) {
        final tp = TextPainter(
          text: TextSpan(text: buffer[r][c], style: textStyle),
          textDirection: TextDirection.ltr,
        );

        tp.layout();
        tp.paint(canvas, Offset(c * 9.5, r * 16.0));
      }
    }
  }

  @override
  bool shouldRepaint(covariant GpuTerminalPainter oldDelegate) {
    return true;
  }
}
