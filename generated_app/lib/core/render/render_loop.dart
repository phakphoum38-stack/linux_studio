import 'package:flutter/scheduler.dart';

class RenderLoop {
  late final Ticker _ticker;
  Function(Duration)? onTick;

  RenderLoop(TickerProvider vsync) {
    _ticker = vsync.createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    onTick?.call(elapsed);
  }

  void start() => _ticker.start();

  void stop() => _ticker.stop();

  void dispose() => _ticker.dispose();
}
