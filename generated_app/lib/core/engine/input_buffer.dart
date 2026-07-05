class InputBuffer {
  String _text = '';
  int _cursor = 0;

  String get text => _text;
  int get cursor => _cursor;

  void clear() {
    _text = '';
    _cursor = 0;
  }

  void set(String value) {
    _text = value;
    _cursor = value.length;
  }

  void insert(String value) {
    _text = _text.substring(0, _cursor) +
        value +
        _text.substring(_cursor);

    _cursor += value.length;
  }

  void backspace() {
    if (_cursor == 0) return;

    _text = _text.substring(0, _cursor - 1) +
        _text.substring(_cursor);

    _cursor--;
  }

  void moveLeft() {
    if (_cursor > 0) _cursor--;
  }

  void moveRight() {
    if (_cursor < _text.length) _cursor++;
  }
}
