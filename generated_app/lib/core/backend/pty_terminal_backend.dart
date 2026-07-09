  @override
  Future<void> stop() async {
    _running = false;

    _reader?.cancel();
    _reader = null;

    _terminal.close();

    await _outputController.close();
    await _errorController.close();
  }
}
