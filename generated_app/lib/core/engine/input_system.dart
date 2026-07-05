class InputSystem {
  Function(String input)? onInput;

  void handleKey(String key) {
    switch (key) {
      case 'enter':
        onInput?.call('\n');
        break;
      case 'backspace':
        onInput?.call('\b');
        break;
      default:
        onInput?.call(key);
    }
  }
}
