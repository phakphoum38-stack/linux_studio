class InputController {
  Function(String key)? onKey;
  Function(int r, int c)? onMouseDown;
  Function(int r, int c)? onMouseDrag;

  void key(String k) {
    onKey?.call(k);
  }

  void mouseDown(int r, int c) {
    onMouseDown?.call(r, c);
  }

  void mouseDrag(int r, int c) {
    onMouseDrag?.call(r, c);
  }
}
