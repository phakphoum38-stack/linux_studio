class AnsiParser {
  static String clean(String input) {
    return input
        .replaceAll('\u001B', '')
        .replaceAll(RegExp(r'\[[0-9;]*m'), '');
  }

  static List<String> splitLines(String input) {
    return input.split('\n');
  }
}
