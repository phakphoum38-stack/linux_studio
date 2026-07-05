import 'dart:async';

class Cursor {
  int row;
  int col;

  bool visible;
  bool blinking;

  Timer? _blinkTimer;

  Cursor({
    this.row = 0,
    this.col = 0,
    this.visible = true,
    this.blinking = true,
  });

  void reset() {
    row = 0;
    col = 0;
  }

  void set(int r, int c) {
    row = r;
    col = c;
  }

  void startBlink(Function() onTick) {
    _blinkTimer?.cancel();

    if (!blinking) return;

    _blinkTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        visible = !visible;
        onTick();
      },
    );
  }

  void stopBlink() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    visible = true;
  }

  void moveLeft() {
    if (col > 0) col--;
  }

  void moveRight(int maxCols) {
    if (col < maxCols - 1) col++;
  }

  void moveUp() {
    if (row > 0) row--;
  }

  void moveDown(int maxRows) {
    if (row < maxRows - 1) row++;
  }
}
