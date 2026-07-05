class CursorManager {
  int row = 0;
  int col = 0;

  bool visible = true;
  bool blink = true;

  void move(int r, int c) {
    row = r;
    col = c;
  }

  void hide() => visible = false;
  void show() => visible = true;

  void toggleBlink() {
    blink = !blink;
  }
}
