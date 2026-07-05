class RenderScheduler {
  DateTime _lastFrame = DateTime.now();

  bool shouldRender() {
    final now = DateTime.now();
    if (now.difference(_lastFrame).inMilliseconds < 16) {
      return false;
    }
    _lastFrame = now;
    return true;
  }
}
