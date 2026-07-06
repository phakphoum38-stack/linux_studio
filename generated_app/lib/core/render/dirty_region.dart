class DirtyRegion {
  int x;
  int y;
  int width;
  int height;

  DirtyRegion(this.x, this.y, this.width, this.height);

  bool contains(int cx, int cy) {
    return cx >= x &&
        cy >= y &&
        cx < x + width &&
        cy < y + height;
  }
}
