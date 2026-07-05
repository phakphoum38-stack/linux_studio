class Utf8Helper {
  static List<String> safeSplit(String input) {
    // `8#`8-`8moji / surrogate pairs
    return input.runes.map((r) => String.fromCharCode(r)).toList();
  }

  static bool isWideChar(String char) {
    final code = char.codeUnitAt(0);
    return code > 0x1100;
  }
}
