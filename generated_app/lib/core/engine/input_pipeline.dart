class InputPipeline {
  final List<String> _queue = [];

  void add(String input) {
    _queue.add(input);
  }

  String flush() {
    final data = _queue.join();
    _queue.clear();
    return data;
  }

  bool get hasData => _queue.isNotEmpty;
}
