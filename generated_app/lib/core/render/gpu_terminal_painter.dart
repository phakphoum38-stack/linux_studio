import 'package:flutter/material.dart';

import '../engine/screen_buffer.dart';
import 'terminal_painter.dart';

/// GPU Terminal Painter
///
/// Release 1.0
///
/// ตอนนี้ใช้ TerminalPainter เดิมไปก่อน
/// เพื่อให้ compile ผ่าน
/// Release 1.1 จะเปลี่ยนเป็น GPU Renderer จริง
class GpuTerminalPainter extends TerminalPainter {
  GpuTerminalPainter(
    ScreenBuffer screen, {
    double fontSize = 14,
    String fontFamily = 'monospace',
  }) : super(
          screen,
          fontSize: fontSize,
          fontFamily: fontFamily,
        );

  @override
  bool shouldRepaint(
    covariant GpuTerminalPainter oldDelegate,
  ) {
    return true;
  }
}
